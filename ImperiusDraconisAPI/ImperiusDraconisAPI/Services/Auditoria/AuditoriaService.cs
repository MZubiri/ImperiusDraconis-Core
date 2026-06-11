using System;
using System.Collections.Generic;
using System.Data;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using ImperiusDraconisAPI.Models.Auditoria;
using ImperiusDraconisAPI.Models.Auditoria.Dtos;

namespace ImperiusDraconisAPI.Services.Auditoria
{
    public interface IAuditoriaService
    {
        Task RegistrarAccesoAsync(int idAlumno, string ip, string userAgent, string fingerprint, bool exito);
        Task<ResumenAuditoriaAcceso?> ObtenerResumenAsync(int idAlumno);
        Task EvaluarAuditoriaAlumnoAsync(int idAlumno);
        Task RegistrarExcepcionAsync(ExcepcionAuditoria excepcion);
        Task<RelacionAccesoNodoDto> ObtenerArbolRelacionesAsync(int idAlumno);
        Task RegistrarDecisionAsync(DecisionAdministrativa decision);
        Task<List<DecisionAdministrativa>> ObtenerHistorialDecisionesAsync(int idAlumno);
        Task RegistrarCuentaEspecialAsync(CuentaEspecial cuentaEspecial);
        Task<List<ExcepcionAuditoria>> ObtenerExcepcionesAsync();
        Task<List<ResumenAuditoriaListadoDto>> ObtenerTodosResumenesAsync();
    }

    public class AuditoriaService : IAuditoriaService
    {
        private readonly string _connectionString;
        private readonly IGeoLocationService _geoLocationService;
        private readonly ILogger<AuditoriaService> _logger;

        public AuditoriaService(IConfiguration configuration, IGeoLocationService geoLocationService, ILogger<AuditoriaService> logger)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection") 
                ?? throw new ArgumentNullException(nameof(configuration));
            _geoLocationService = geoLocationService;
            _logger = logger;
        }

        public async Task RegistrarAccesoAsync(int idAlumno, string ip, string userAgent, string fingerprint, bool exito)
        {
            string dispositivo = ParsearDispositivo(userAgent);
            var (pais, ciudad, isp) = _geoLocationService.ObtenerMetadatosIp(ip);

            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            // 1. Guardar Acceso
            using (var cmdAcceso = new SqlCommand(@"
                INSERT INTO dbo.HistorialAccesos 
                (IdAlumno, DireccionIP, UserAgent, FingerprintHash, TipoDispositivo, PaisCodigo, Ciudad, ProveedorInternet, Exito, FechaAcceso) 
                VALUES 
                (@IdAlumno, @IP, @UA, @FP, @Dispositivo, @Pais, @Ciudad, @ISP, @Exito, GETDATE())", conn))
            {
                cmdAcceso.Parameters.AddWithValue("@IdAlumno", idAlumno);
                cmdAcceso.Parameters.AddWithValue("@IP", ip);
                cmdAcceso.Parameters.AddWithValue("@UA", userAgent ?? (object)DBNull.Value);
                cmdAcceso.Parameters.AddWithValue("@FP", fingerprint);
                cmdAcceso.Parameters.AddWithValue("@Dispositivo", dispositivo);
                cmdAcceso.Parameters.AddWithValue("@Pais", pais ?? (object)DBNull.Value);
                cmdAcceso.Parameters.AddWithValue("@Ciudad", ciudad ?? (object)DBNull.Value);
                cmdAcceso.Parameters.AddWithValue("@ISP", isp ?? (object)DBNull.Value);
                cmdAcceso.Parameters.AddWithValue("@Exito", exito);
                await cmdAcceso.ExecuteNonQueryAsync();
            }

            if (exito)
            {
                // 2. Controlar Aparición de Nuevo Dispositivo (Fingerprint)
                bool esNuevoDispositivo = false;
                using (var cmdCheck = new SqlCommand("SELECT COUNT(*) FROM dbo.DispositivosAlumno WHERE IdAlumno = @Id AND FingerprintHash = @FP", conn))
                {
                    cmdCheck.Parameters.AddWithValue("@Id", idAlumno);
                    cmdCheck.Parameters.AddWithValue("@FP", fingerprint);
                    esNuevoDispositivo = Convert.ToInt32(await cmdCheck.ExecuteScalarAsync()) == 0;
                }

                if (esNuevoDispositivo)
                {
                    // Loggear evento
                    using (var cmdLogEv = new SqlCommand(@"
                        INSERT INTO dbo.AuditoriaEventos (TipoEvento, OrigenEvento, Severidad, IdAlumno, ValorNuevo, FechaEvento)
                        VALUES ('DISPOSITIVO_NUEVO', 'LOGIN', 'INFO', @Id, @FP, GETDATE())", conn))
                    {
                        cmdLogEv.Parameters.AddWithValue("@Id", idAlumno);
                        cmdLogEv.Parameters.AddWithValue("@FP", fingerprint);
                        await cmdLogEv.ExecuteNonQueryAsync();
                    }
                }

                // 3. Upsert Dispositivo
                using (var cmdMergeDisp = new SqlCommand(@"
                    MERGE dbo.DispositivosAlumno AS Target
                    USING (SELECT @IdAlumno AS Id, @FP AS Hash, @UA AS Agent) AS Source
                    ON (Target.IdAlumno = Source.Id AND Target.FingerprintHash = Source.Hash)
                    WHEN MATCHED THEN
                        UPDATE SET UltimoUserAgent = Source.Agent, FechaUltimoAcceso = GETDATE()
                    WHEN NOT MATCHED THEN
                        INSERT (IdAlumno, FingerprintHash, UltimoUserAgent, FechaPrimerAcceso, FechaUltimoAcceso)
                        VALUES (Source.Id, Source.Hash, Source.Agent, GETDATE(), GETDATE());", conn))
                {
                    cmdMergeDisp.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    cmdMergeDisp.Parameters.AddWithValue("@FP", fingerprint);
                    cmdMergeDisp.Parameters.AddWithValue("@UA", userAgent ?? (object)DBNull.Value);
                    await cmdMergeDisp.ExecuteNonQueryAsync();
                }

                // 4. Procesar Vínculos y Auditoría
                await ProcesarVinculosDeCuentasAsync(idAlumno, fingerprint, ip, conn);
                await EvaluarAuditoriaInternaAsync(idAlumno, conn);
            }
        }

        public async Task RegistrarExcepcionAsync(ExcepcionAuditoria excepcion)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using (var cmd = new SqlCommand(@"
                INSERT INTO dbo.ExcepcionesAuditoria 
                (TipoExcepcion, ValorA, ValorB, Motivo, FechaCreado, IdAdministrador, Activa) 
                VALUES 
                (@Tipo, @ValA, @ValB, @Motivo, GETDATE(), @IdAdmin, 1)", conn))
            {
                cmd.Parameters.AddWithValue("@Tipo", excepcion.TipoExcepcion);
                cmd.Parameters.AddWithValue("@ValA", excepcion.ValorA);
                cmd.Parameters.AddWithValue("@ValB", excepcion.ValorB ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Motivo", excepcion.Motivo ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@IdAdmin", excepcion.IdAdministrador);
                await cmd.ExecuteNonQueryAsync();
            }

            // Registrar Evento
            using (var cmdEvent = new SqlCommand(@"
                INSERT INTO dbo.AuditoriaEventos (TipoEvento, OrigenEvento, Severidad, IdAlumno, ValorNuevo, DetallesJson, FechaEvento)
                VALUES ('EXCEPCION_CREADA', 'ADMINISTRADOR', 'LOW', @Id, @Tipo, @Detalles, GETDATE())", conn))
            {
                cmdEvent.Parameters.AddWithValue("@Id", int.Parse(excepcion.ValorA));
                cmdEvent.Parameters.AddWithValue("@Tipo", excepcion.TipoExcepcion);
                cmdEvent.Parameters.AddWithValue("@Detalles", JsonSerializer.Serialize(excepcion));
                await cmdEvent.ExecuteNonQueryAsync();
            }

            await EvaluarAuditoriaInternaAsync(int.Parse(excepcion.ValorA), conn);
        }

        public async Task<RelacionAccesoNodoDto> ObtenerArbolRelacionesAsync(int idAlumno)
        {
            var raiz = new RelacionAccesoNodoDto();

            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();

            using (var cmdName = new SqlCommand("SELECT Nombre FROM dbo.Alumnos WHERE IdAlumno = @Id", conn))
            {
                cmdName.Parameters.AddWithValue("@Id", idAlumno);
                string nombre = Convert.ToString(await cmdName.ExecuteScalarAsync()) ?? $"Alumno #{idAlumno}";
                raiz.Label = nombre;
                raiz.Tipo = "ALUMNO";
                raiz.Valor = idAlumno.ToString();
            }

            // 1. Obtener Dispositivos
            var dispositivos = new List<(string Hash, string Alias)>();
            using (var cmdDev = new SqlCommand(@"
                SELECT FingerprintHash, NombreDispositivoManual 
                FROM dbo.DispositivosAlumno 
                WHERE IdAlumno = @Id", conn))
            {
                cmdDev.Parameters.AddWithValue("@Id", idAlumno);
                using var reader = await cmdDev.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    string hash = reader.GetString(0);
                    string alias = reader.IsDBNull(1) ? $"Huella {hash.Substring(0, 8)}" : reader.GetString(1);
                    dispositivos.Add((hash, alias));
                }
            }

            var nodoDispositivos = new RelacionAccesoNodoDto { Label = "Dispositivos (Huellas)", Tipo = "GRUPO" };
            foreach (var dev in dispositivos)
            {
                var devNode = new RelacionAccesoNodoDto
                {
                    Label = dev.Alias,
                    Tipo = "DISPOSITIVO",
                    Valor = dev.Hash
                };

                // Buscar otras cuentas que usaron este fingerprint
                using (var cmdShared = new SqlCommand(@"
                    SELECT DISTINCT A.IdAlumno, A.Nombre 
                    FROM dbo.HistorialAccesos H
                    INNER JOIN dbo.Alumnos A ON A.IdAlumno = H.IdAlumno
                    WHERE H.FingerprintHash = @FP AND H.IdAlumno <> @IdAlumno AND H.Exito = 1", conn))
                {
                    cmdShared.Parameters.AddWithValue("@FP", dev.Hash);
                    cmdShared.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    using var readerShared = await cmdShared.ExecuteReaderAsync();
                    while (await readerShared.ReadAsync())
                    {
                        devNode.Hijos.Add(new RelacionAccesoNodoDto
                        {
                            Label = $"{readerShared.GetString(1)} (ID: {readerShared.GetInt32(0)})",
                            Tipo = "ALUMNO_RELACIONADO",
                            Valor = readerShared.GetInt32(0).ToString()
                        });
                    }
                }
                nodoDispositivos.Hijos.Add(devNode);
            }
            if (nodoDispositivos.Hijos.Count > 0) raiz.Hijos.Add(nodoDispositivos);

            // 2. Obtener Direcciones IP
            var ips = new List<string>();
            using (var cmdIp = new SqlCommand(@"
                SELECT DISTINCT DireccionIP 
                FROM dbo.HistorialAccesos 
                WHERE IdAlumno = @Id AND Exito = 1", conn))
            {
                cmdIp.Parameters.AddWithValue("@Id", idAlumno);
                using var reader = await cmdIp.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    ips.Add(reader.GetString(0));
                }
            }

            var nodoIps = new RelacionAccesoNodoDto { Label = "Direcciones IP Utilizadas", Tipo = "GRUPO" };
            foreach (var ip in ips)
            {
                var ipNode = new RelacionAccesoNodoDto
                {
                    Label = ip,
                    Tipo = "IP",
                    Valor = ip
                };

                // Buscar otras cuentas que usaron esta IP
                using (var cmdSharedIp = new SqlCommand(@"
                    SELECT DISTINCT A.IdAlumno, A.Nombre 
                    FROM dbo.HistorialAccesos H
                    INNER JOIN dbo.Alumnos A ON A.IdAlumno = H.IdAlumno
                    WHERE H.DireccionIP = @IP AND H.IdAlumno <> @IdAlumno AND H.Exito = 1", conn))
                {
                    cmdSharedIp.Parameters.AddWithValue("@IP", ip);
                    cmdSharedIp.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    using var readerSharedIp = await cmdSharedIp.ExecuteReaderAsync();
                    while (await readerSharedIp.ReadAsync())
                    {
                        ipNode.Hijos.Add(new RelacionAccesoNodoDto
                        {
                            Label = $"{readerSharedIp.GetString(1)} (ID: {readerSharedIp.GetInt32(0)})",
                            Tipo = "ALUMNO_RELACIONADO",
                            Valor = readerSharedIp.GetInt32(0).ToString()
                        });
                    }
                }
                nodoIps.Hijos.Add(ipNode);
            }
            if (nodoIps.Hijos.Count > 0) raiz.Hijos.Add(nodoIps);

            return raiz;
        }

        public async Task<ResumenAuditoriaAcceso?> ObtenerResumenAsync(int idAlumno)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT IdAlumno, RelevanciaAuditoria, MotivosDetalle, EvidenciasJson, UltimaEvaluacion 
                FROM dbo.ResumenAuditoriaAccesos 
                WHERE IdAlumno = @Id", conn);
            cmd.Parameters.AddWithValue("@Id", idAlumno);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new ResumenAuditoriaAcceso
                {
                    IdAlumno = reader.GetInt32(0),
                    RelevanciaAuditoria = reader.GetInt32(1),
                    MotivosDetalle = reader.GetString(2),
                    EvidenciasJson = reader.GetString(3),
                    UltimaEvaluacion = reader.GetDateTime(4)
                };
            }
            return null;
        }

        public async Task EvaluarAuditoriaAlumnoAsync(int idAlumno)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            await EvaluarAuditoriaInternaAsync(idAlumno, conn);
        }

        private async Task EvaluarAuditoriaInternaAsync(int idAlumno, SqlConnection conn)
        {
            decimal multiplicador = 1.00m;

            // 1. Obtener Multiplicador de Cuenta Especial
            using (var cmdEsp = new SqlCommand("SELECT MultiplicadorAuditoria FROM dbo.CuentasEspeciales WHERE IdAlumno = @Id", conn))
            {
                cmdEsp.Parameters.AddWithValue("@Id", idAlumno);
                object? res = await cmdEsp.ExecuteScalarAsync();
                if (res != null)
                {
                    multiplicador = Convert.ToDecimal(res);
                }
            }

            int scoreBruto = 0;
            var motivos = new List<string>();
            var evidencias = new Dictionary<string, object>();

            // 2. Validar Excepciones Permanentes
            using (var cmdExc = new SqlCommand(@"
                SELECT COUNT(*) FROM dbo.ExcepcionesAuditoria 
                WHERE Activa = 1 AND (
                    (TipoExcepcion = 'RELACION_AUTORIZADA' AND ((ValorA = @IdStr AND ValorB = @IdStr) OR (ValorA = @IdStr AND ValorB = @IdStr))) OR
                    (TipoExcepcion = 'DISPOSITIVO_AUTORIZADO' AND ValorA IN (SELECT FingerprintHash FROM dbo.DispositivosAlumno WHERE IdAlumno = @IdAlumno))
                )", conn))
            {
                cmdExc.Parameters.AddWithValue("@IdAlumno", idAlumno);
                cmdExc.Parameters.AddWithValue("@IdStr", idAlumno.ToString());
                int excepcionesActivas = Convert.ToInt32(await cmdExc.ExecuteScalarAsync());

                if (excepcionesActivas > 0)
                {
                    await GuardarResumenAuditoriaAsync(idAlumno, 10, "Excepción administrativa permanente activa.", "{}", conn);
                    return;
                }
            }

            // Regla A: Fingerprint compartido
            using (var cmdFp = new SqlCommand(@"
                SELECT COUNT(DISTINCT IdAlumno) FROM dbo.HistorialAccesos 
                WHERE FingerprintHash IN (
                    SELECT DISTINCT FingerprintHash FROM dbo.HistorialAccesos WHERE IdAlumno = @IdAlumno AND Exito = 1
                ) AND IdAlumno <> @IdAlumno AND Exito = 1", conn))
            {
                cmdFp.Parameters.AddWithValue("@IdAlumno", idAlumno);
                int cuentasFp = Convert.ToInt32(await cmdFp.ExecuteScalarAsync());
                if (cuentasFp > 0)
                {
                    scoreBruto += 40;
                    motivos.Add($"Comparte hardware con {cuentasFp} cuenta(s)");
                    evidencias.Add("HuellasCompartidas", cuentasFp);
                }
            }

            // Regla B: IP compartida
            using (var cmdIp = new SqlCommand(@"
                SELECT COUNT(DISTINCT IdAlumno) FROM dbo.HistorialAccesos 
                WHERE DireccionIP IN (
                    SELECT DISTINCT DireccionIP FROM dbo.HistorialAccesos WHERE IdAlumno = @IdAlumno AND Exito = 1
                ) AND IdAlumno <> @IdAlumno AND Exito = 1", conn))
            {
                cmdIp.Parameters.AddWithValue("@IdAlumno", idAlumno);
                int cuentasIp = Convert.ToInt32(await cmdIp.ExecuteScalarAsync());
                if (cuentasIp > 0)
                {
                    scoreBruto += 10;
                    motivos.Add($"Comparte dirección IP con {cuentasIp} cuenta(s)");
                    evidencias.Add("IpsCompartidas", cuentasIp);
                }
            }

            // 3. Aplicar Multiplicador de Cuenta Especial
            int scoreFinal = (int)Math.Round(scoreBruto * multiplicador);
            if (scoreFinal > 100) scoreFinal = 100;

            if (multiplicador < 1.00m)
            {
                motivos.Add($"Score atenuado por tipo de cuenta especial (Factor: {multiplicador})");
            }

            string motivosTxt = string.Join("; ", motivos);
            string jsonEvidencias = JsonSerializer.Serialize(evidencias);

            // 4. Rastrear cambios significativos en Relevancia
            int scoreAnterior = 0;
            using (var cmdPrev = new SqlCommand("SELECT RelevanciaAuditoria FROM dbo.ResumenAuditoriaAccesos WHERE IdAlumno = @Id", conn))
            {
                cmdPrev.Parameters.AddWithValue("@Id", idAlumno);
                object? val = await cmdPrev.ExecuteScalarAsync();
                if (val != null) scoreAnterior = Convert.ToInt32(val);
            }

            if (Math.Abs(scoreFinal - scoreAnterior) >= 20)
            {
                string severidad = "INFO";
                if (scoreFinal >= 70) severidad = "HIGH";
                if (scoreFinal >= 90) severidad = "CRITICAL";

                // Registrar evento de cambio de relevancia
                using (var cmdLogEv = new SqlCommand(@"
                    INSERT INTO dbo.AuditoriaEventos (TipoEvento, OrigenEvento, Severidad, IdAlumno, ValorAnterior, ValorNuevo, FechaEvento)
                    VALUES ('CAMBIO_RELEVANCIA', 'SISTEMA', @Sev, @Id, @Prev, @New, GETDATE())", conn))
                {
                    cmdLogEv.Parameters.AddWithValue("@Id", idAlumno);
                    cmdLogEv.Parameters.AddWithValue("@Sev", severidad);
                    cmdLogEv.Parameters.AddWithValue("@Prev", scoreAnterior.ToString());
                    cmdLogEv.Parameters.AddWithValue("@New", scoreFinal.ToString());
                    await cmdLogEv.ExecuteNonQueryAsync();
                }
            }

            await GuardarResumenAuditoriaAsync(idAlumno, scoreFinal, motivosTxt, jsonEvidencias, conn);
        }

        private async Task GuardarResumenAuditoriaAsync(int idAlumno, int score, string motivos, string evidencias, SqlConnection conn)
        {
            using var cmd = new SqlCommand(@"
                MERGE dbo.ResumenAuditoriaAccesos AS Target
                USING (SELECT @IdAlumno AS Id, @Score AS Score, @Motivos AS Motivos, @Evidencias AS Evidencias) AS Source
                ON (Target.IdAlumno = Source.Id)
                WHEN MATCHED THEN
                    UPDATE SET RelevanciaAuditoria = Source.Score, MotivosDetalle = Source.Motivos, EvidenciasJson = Source.Evidencias, UltimaEvaluacion = GETDATE()
                WHEN NOT MATCHED THEN
                    INSERT (IdAlumno, RelevanciaAuditoria, MotivosDetalle, EvidenciasJson, UltimaEvaluacion)
                    VALUES (Source.Id, Source.Score, Source.Motivos, Source.Evidencias, GETDATE());", conn);

            cmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
            cmd.Parameters.AddWithValue("@Score", score);
            cmd.Parameters.AddWithValue("@Motivos", motivos);
            cmd.Parameters.AddWithValue("@Evidencias", evidencias);

            await cmd.ExecuteNonQueryAsync();
        }

        private async Task ProcesarVinculosDeCuentasAsync(int idAlumno, string fingerprint, string ip, SqlConnection conn)
        {
            using var cmd = new SqlCommand(@"
                SELECT DISTINCT IdAlumno FROM dbo.HistorialAccesos 
                WHERE FingerprintHash = @FP AND IdAlumno <> @IdAlumno AND Exito = 1", conn);
            cmd.Parameters.AddWithValue("@FP", fingerprint);
            cmd.Parameters.AddWithValue("@IdAlumno", idAlumno);

            var rels = new List<int>();
            using (var r = await cmd.ExecuteReaderAsync()) { while (await r.ReadAsync()) rels.Add(r.GetInt32(0)); }

            foreach (var relId in rels)
            {
                int menor = Math.Min(idAlumno, relId);
                int mayor = Math.Max(idAlumno, relId);

                bool esNuevoVinculo = false;
                using (var cmdCheck = new SqlCommand("SELECT COUNT(*) FROM dbo.CuentasVinculadas WHERE IdAlumnoA = @Menor AND IdAlumnoB = @Mayor AND TipoEvidencia = 'FINGERPRINT_COMPARTIDA'", conn))
                {
                    cmdCheck.Parameters.AddWithValue("@Menor", menor);
                    cmdCheck.Parameters.AddWithValue("@Mayor", mayor);
                    esNuevoVinculo = Convert.ToInt32(await cmdCheck.ExecuteScalarAsync()) == 0;
                }

                if (esNuevoVinculo)
                {
                    using (var cmdLogEv = new SqlCommand(@"
                        INSERT INTO dbo.AuditoriaEventos (TipoEvento, OrigenEvento, Severidad, IdAlumno, IdAlumnoRelacionado, ValorNuevo, FechaEvento)
                        VALUES ('VINCULO_NUEVO', 'SISTEMA', 'HIGH', @IdA, @IdB, 'FINGERPRINT_COMPARTIDA', GETDATE())", conn))
                    {
                        cmdLogEv.Parameters.AddWithValue("@IdA", menor);
                        cmdLogEv.Parameters.AddWithValue("@IdB", mayor);
                        await cmdLogEv.ExecuteNonQueryAsync();
                    }
                }

                using var cmdMerge = new SqlCommand(@"
                    MERGE dbo.CuentasVinculadas AS Target
                    USING (SELECT @Menor AS IdA, @Mayor AS IdB, 'FINGERPRINT_COMPARTIDA' AS Tipo) AS Source
                    ON (Target.IdAlumnoA = Source.IdA AND Target.IdAlumnoB = Source.IdB AND Target.TipoEvidencia = Source.Tipo)
                    WHEN MATCHED THEN
                        UPDATE SET FuerzaVinculo = Target.FuerzaVinculo + 1, ActualizadoEn = GETDATE()
                    WHEN NOT MATCHED THEN
                        INSERT (IdAlumnoA, IdAlumnoB, TipoEvidencia, FuerzaVinculo, CreadoEn, ActualizadoEn)
                        VALUES (Source.IdA, Source.IdB, Source.Tipo, 1, GETDATE(), GETDATE());", conn);

                cmdMerge.Parameters.AddWithValue("@Menor", menor);
                cmdMerge.Parameters.AddWithValue("@Mayor", mayor);
                await cmdMerge.ExecuteNonQueryAsync();
            }
        }

        private string ParsearDispositivo(string userAgent)
        {
            if (string.IsNullOrEmpty(userAgent)) return "Desconocido";
            string ua = userAgent.ToLower();
            if (ua.Contains("mobile") || ua.Contains("android") || ua.Contains("iphone")) return "Mobile";
            if (ua.Contains("ipad") || ua.Contains("tablet")) return "Tablet";
            return "Desktop";
        }

        public async Task RegistrarDecisionAsync(DecisionAdministrativa decision)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                INSERT INTO dbo.DecisionesAdministrativas 
                (IdAlumno, IdAlumnoRelacionado, Decision, Motivo, NotasInternas, IdAdministrador, FechaDecision) 
                VALUES 
                (@IdAlumno, @IdAlumnoRelacionado, @Decision, @Motivo, @Notas, @IdAdmin, GETDATE())", conn);

            cmd.Parameters.AddWithValue("@IdAlumno", decision.IdAlumno);
            cmd.Parameters.AddWithValue("@IdAlumnoRelacionado", decision.IdAlumnoRelacionado ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Decision", decision.Decision);
            cmd.Parameters.AddWithValue("@Motivo", decision.Motivo ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Notas", decision.NotasInternas ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@IdAdmin", decision.IdAdministrador);

            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            using (var cmdEvent = new SqlCommand(@"
                INSERT INTO dbo.AuditoriaEventos (TipoEvento, OrigenEvento, Severidad, IdAlumno, IdAlumnoRelacionado, ValorNuevo, DetallesJson, FechaEvento)
                VALUES ('DECISION_REGISTRADA', 'ADMINISTRADOR', 'MEDIUM', @Id, @RelId, @Decision, @Detalles, GETDATE())", conn))
            {
                cmdEvent.Parameters.AddWithValue("@Id", decision.IdAlumno);
                cmdEvent.Parameters.AddWithValue("@RelId", decision.IdAlumnoRelacionado ?? (object)DBNull.Value);
                cmdEvent.Parameters.AddWithValue("@Decision", decision.Decision);
                cmdEvent.Parameters.AddWithValue("@Detalles", JsonSerializer.Serialize(decision));
                await cmdEvent.ExecuteNonQueryAsync();
            }

            await EvaluarAuditoriaInternaAsync(decision.IdAlumno, conn);
        }

        public async Task<List<DecisionAdministrativa>> ObtenerHistorialDecisionesAsync(int idAlumno)
        {
            var historial = new List<DecisionAdministrativa>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT Id, IdAlumno, IdAlumnoRelacionado, Decision, Motivo, NotasInternas, IdAdministrador, FechaDecision 
                FROM dbo.DecisionesAdministrativas 
                WHERE IdAlumno = @IdAlumno 
                ORDER BY FechaDecision DESC", conn);
            cmd.Parameters.AddWithValue("@IdAlumno", idAlumno);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                historial.Add(new DecisionAdministrativa
                {
                    Id = reader.GetInt32(0),
                    IdAlumno = reader.GetInt32(1),
                    IdAlumnoRelacionado = reader.IsDBNull(2) ? null : reader.GetInt32(2),
                    Decision = reader.GetString(3),
                    Motivo = reader.IsDBNull(4) ? null : reader.GetString(4),
                    NotasInternas = reader.IsDBNull(5) ? null : reader.GetString(5),
                    IdAdministrador = reader.GetInt32(6),
                    FechaDecision = reader.GetDateTime(7)
                });
            }
            return historial;
        }

        public async Task RegistrarCuentaEspecialAsync(CuentaEspecial cuentaEspecial)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                MERGE dbo.CuentasEspeciales AS Target
                USING (SELECT @IdAlumno AS Id, @Tipo AS Tipo, @Desc AS [Desc], @Mult AS Mult) AS Source
                ON (Target.IdAlumno = Source.Id)
                WHEN MATCHED THEN
                    UPDATE SET TipoCuenta = Source.Tipo, Descripcion = Source.[Desc], MultiplicadorAuditoria = Source.Mult
                WHEN NOT MATCHED THEN
                    INSERT (IdAlumno, TipoCuenta, Descripcion, MultiplicadorAuditoria, FechaRegistro)
                    VALUES (Source.Id, Source.Tipo, Source.[Desc], Source.Mult, GETDATE());", conn);

            cmd.Parameters.AddWithValue("@IdAlumno", cuentaEspecial.IdAlumno);
            cmd.Parameters.AddWithValue("@Tipo", cuentaEspecial.TipoCuenta);
            cmd.Parameters.AddWithValue("@Desc", cuentaEspecial.Descripcion ?? (object)DBNull.Value);
            cmd.Parameters.AddWithValue("@Mult", cuentaEspecial.MultiplicadorAuditoria);

            await conn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();

            using (var cmdEvent = new SqlCommand(@"
                INSERT INTO dbo.AuditoriaEventos (TipoEvento, OrigenEvento, Severidad, IdAlumno, ValorNuevo, DetallesJson, FechaEvento)
                VALUES ('CUENTA_ESPECIAL_REGISTRADA', 'ADMINISTRADOR', 'LOW', @Id, @Tipo, @Detalles, GETDATE())", conn))
            {
                cmdEvent.Parameters.AddWithValue("@Id", cuentaEspecial.IdAlumno);
                cmdEvent.Parameters.AddWithValue("@Tipo", cuentaEspecial.TipoCuenta);
                cmdEvent.Parameters.AddWithValue("@Detalles", JsonSerializer.Serialize(cuentaEspecial));
                await cmdEvent.ExecuteNonQueryAsync();
            }

            await EvaluarAuditoriaInternaAsync(cuentaEspecial.IdAlumno, conn);
        }

        public async Task<List<ExcepcionAuditoria>> ObtenerExcepcionesAsync()
        {
            var excepciones = new List<ExcepcionAuditoria>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT Id, TipoExcepcion, ValorA, ValorB, Motivo, FechaCreado, IdAdministrador, Activa 
                FROM dbo.ExcepcionesAuditoria 
                WHERE Activa = 1
                ORDER BY FechaCreado DESC", conn);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                excepciones.Add(new ExcepcionAuditoria
                {
                    Id = reader.GetInt32(0),
                    TipoExcepcion = reader.GetString(1),
                    ValorA = reader.GetString(2),
                    ValorB = reader.IsDBNull(3) ? null : reader.GetString(3),
                    Motivo = reader.IsDBNull(4) ? null : reader.GetString(4),
                    FechaCreado = reader.GetDateTime(5),
                    IdAdministrador = reader.GetInt32(6),
                    Activa = reader.GetBoolean(7)
                });
            }
            return excepciones;
        }

        public async Task<List<ResumenAuditoriaListadoDto>> ObtenerTodosResumenesAsync()
        {
            var resumenes = new List<ResumenAuditoriaListadoDto>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT R.IdAlumno, A.Nombre, R.RelevanciaAuditoria, R.MotivosDetalle, R.EvidenciasJson, R.UltimaEvaluacion 
                FROM dbo.ResumenAuditoriaAccesos R
                INNER JOIN dbo.Alumnos A ON A.IdAlumno = R.IdAlumno
                ORDER BY R.RelevanciaAuditoria DESC, R.UltimaEvaluacion DESC", conn);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                resumenes.Add(new ResumenAuditoriaListadoDto
                {
                    IdAlumno = reader.GetInt32(0),
                    NombreAlumno = reader.GetString(1),
                    RelevanciaAuditoria = reader.GetInt32(2),
                    MotivosDetalle = reader.GetString(3),
                    EvidenciasJson = reader.GetString(4),
                    UltimaEvaluacion = reader.GetDateTime(5)
                });
            }
            return resumenes;
        }
    }
}
