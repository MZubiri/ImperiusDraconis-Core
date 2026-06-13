using System.Data;
using System.Globalization;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Biblioteca;
using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Services;

public sealed class BibliotecaService
{
    private readonly SqlConnectionFactory _connectionFactory;
    private readonly IWebHostEnvironment _environment;

    public BibliotecaService(SqlConnectionFactory connectionFactory, IWebHostEnvironment environment)
    {
        _connectionFactory = connectionFactory;
        _environment = environment;
    }

    public bool ValidarPassword(string password)
    {
        return string.Equals(password?.Trim(), "Hermione", StringComparison.Ordinal);
    }

    public async Task<IReadOnlyList<BibliotecaCategoriaDto>> ObtenerCategoriasAsync(CancellationToken cancellationToken)
    {
        var result = new List<BibliotecaCategoriaDto>();
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            "SELECT Id, Nombre, Descripcion FROM BibliotecaCategorias WHERE Activo = 1 ORDER BY Nombre",
            connection);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            result.Add(new BibliotecaCategoriaDto
            {
                Id = Convert.ToInt32(reader["Id"], CultureInfo.InvariantCulture),
                Nombre = reader["Nombre"]?.ToString() ?? string.Empty,
                Descripcion = reader["Descripcion"] == DBNull.Value ? null : reader["Descripcion"]?.ToString()
            });
        }

        return result;
    }

    public async Task<IReadOnlyList<BibliotecaLibroDto>> ObtenerLibrosAsync(
        int idAlumno,
        int? categoriaId,
        string? busqueda,
        bool soloMisLibros,
        CancellationToken cancellationToken)
    {
        var result = new List<BibliotecaLibroDto>();
        
        // 1. Verificar si tiene suscripcion activa
        var tieneSuscripcion = await TieneSuscripcionActivaAsync(idAlumno, cancellationToken);

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        var sql = """
            SELECT 
                L.Id, 
                L.Titulo, 
                L.Autor, 
                L.Sinopsis, 
                L.IdCategoria, 
                C.Nombre AS CategoriaNombre, 
                L.Formato, 
                L.PrecioDracoins,
                CASE WHEN ALC.Id IS NOT NULL THEN 1 ELSE 0 END AS Comprado
            FROM BibliotecaLibros L
            LEFT JOIN BibliotecaCategorias C ON C.Id = L.IdCategoria
            LEFT JOIN AlumnosLibrosComprados ALC ON ALC.IdLibro = L.Id AND ALC.IdAlumno = @IdAlumno
            WHERE L.Activo = 1
            """;

        var filters = new List<string>();
        if (categoriaId.HasValue)
        {
            filters.Add("L.IdCategoria = @CategoriaId");
        }
        if (!string.IsNullOrWhiteSpace(busqueda))
        {
            filters.Add("(L.Titulo LIKE @Busqueda OR L.Autor LIKE @Busqueda OR L.Sinopsis LIKE @Busqueda)");
        }
        if (soloMisLibros && !tieneSuscripcion)
        {
            filters.Add("(L.PrecioDracoins = 0 OR ALC.Id IS NOT NULL)");
        }

        if (filters.Count > 0)
        {
            sql += " AND " + string.Join(" AND ", filters);
        }

        sql += " ORDER BY L.Titulo";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        if (categoriaId.HasValue)
        {
            command.Parameters.AddWithValue("@CategoriaId", categoriaId.Value);
        }
        if (!string.IsNullOrWhiteSpace(busqueda))
        {
            command.Parameters.AddWithValue("@Busqueda", $"%{busqueda.Trim()}%");
        }

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            var precio = Convert.ToDecimal(reader["PrecioDracoins"], CultureInfo.InvariantCulture);
            var comprado = Convert.ToInt32(reader["Comprado"], CultureInfo.InvariantCulture) == 1;

            result.Add(new BibliotecaLibroDto
            {
                Id = Convert.ToInt32(reader["Id"], CultureInfo.InvariantCulture),
                Titulo = reader["Titulo"]?.ToString() ?? string.Empty,
                Autor = reader["Autor"]?.ToString() ?? string.Empty,
                Sinopsis = reader["Sinopsis"] == DBNull.Value ? null : reader["Sinopsis"]?.ToString(),
                IdCategoria = reader["IdCategoria"] == DBNull.Value ? null : Convert.ToInt32(reader["IdCategoria"], CultureInfo.InvariantCulture),
                CategoriaNombre = reader["CategoriaNombre"] == DBNull.Value ? "Sin Categoria" : reader["CategoriaNombre"]?.ToString() ?? string.Empty,
                Formato = reader["Formato"]?.ToString() ?? string.Empty,
                PrecioDracoins = precio,
                Comprado = tieneSuscripcion || precio == 0 || comprado
            });
        }

        return result;
    }

    public async Task<string?> ObtenerRutaArchivoLibroAsync(int id, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            "SELECT RutaArchivo FROM BibliotecaLibros WHERE Id = @Id AND Activo = 1",
            connection);
        command.Parameters.AddWithValue("@Id", id);

        var result = await command.ExecuteScalarAsync(cancellationToken);
        return result == DBNull.Value || result == null ? null : result.ToString();
    }

    public async Task<bool> ComprarLibroAsync(int idAlumno, int idLibro, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var transaction = connection.BeginTransaction();

        try
        {
            // 1. Obtener detalles del libro
            decimal precio = 0;
            using (var getLibroCommand = new SqlCommand(
                "SELECT PrecioDracoins FROM BibliotecaLibros WHERE Id = @IdLibro AND Activo = 1",
                connection,
                transaction))
            {
                getLibroCommand.Parameters.AddWithValue("@IdLibro", idLibro);
                var result = await getLibroCommand.ExecuteScalarAsync(cancellationToken);
                if (result == null || result == DBNull.Value)
                {
                    throw new BusinessRuleException("El libro seleccionado no existe o no esta disponible.");
                }
                precio = Convert.ToDecimal(result, CultureInfo.InvariantCulture);
            }

            // 2. Verificar si ya lo compro
            using (var checkCompravCommand = new SqlCommand(
                "SELECT COUNT(*) FROM AlumnosLibrosComprados WHERE IdAlumno = @IdAlumno AND IdLibro = @IdLibro",
                connection,
                transaction))
            {
                checkCompravCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                checkCompravCommand.Parameters.AddWithValue("@IdLibro", idLibro);
                var count = Convert.ToInt32(await checkCompravCommand.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
                if (count > 0)
                {
                    return true; // Ya esta comprado
                }
            }

            // 3. Verificar saldo de Dracoins del alumno
            decimal saldo = 0;
            using (var checkSaldoCommand = new SqlCommand(
                "SELECT Dracoins FROM Alumnos WHERE IdAlumno = @IdAlumno",
                connection,
                transaction))
            {
                checkSaldoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                var result = await checkSaldoCommand.ExecuteScalarAsync(cancellationToken);
                if (result == null || result == DBNull.Value)
                {
                    throw new BusinessRuleException("El alumno no existe.");
                }
                saldo = Convert.ToDecimal(result, CultureInfo.InvariantCulture);
            }

            if (saldo < precio)
            {
                throw new BusinessRuleException($"Saldo insuficiente. El libro cuesta {precio} Dracoins y tienes {saldo} Dracoins.");
            }

            // 4. Descontar Dracoins
            using (var updateSaldoCommand = new SqlCommand(
                "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAlumno",
                connection,
                transaction))
            {
                updateSaldoCommand.Parameters.AddWithValue("@Monto", precio);
                updateSaldoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await updateSaldoCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            // 5. Registrar transaccion de Dracoins (para el historial)
            using (var insertMovCommand = new SqlCommand(
                """
                INSERT INTO MovimientosDracoins (
                    CodigoRemitente, 
                    CodigoDestinatario, 
                    Monto, 
                    Fecha, 
                    Observacion, 
                    IdAlumnoReferencia
                ) VALUES (
                    (SELECT Codigo FROM Alumnos WHERE IdAlumno = @IdAlumno),
                    'COBRO_BIBLIOTECA',
                    @Monto,
                    GETDATE(),
                    'Compra de libro en la biblioteca',
                    @IdAlumno
                )
                """,
                connection,
                transaction))
            {
                insertMovCommand.Parameters.AddWithValue("@Monto", precio);
                insertMovCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await insertMovCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            // 6. Registrar libro comprado
            using (var insertCompraCommand = new SqlCommand(
                "INSERT INTO AlumnosLibrosComprados (IdAlumno, IdLibro, MontoPagado) VALUES (@IdAlumno, @IdLibro, @Monto)",
                connection,
                transaction))
            {
                insertCompraCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                insertCompraCommand.Parameters.AddWithValue("@IdLibro", idLibro);
                insertCompraCommand.Parameters.AddWithValue("@Monto", precio);
                await insertCompraCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            await transaction.CommitAsync(cancellationToken);
            return true;
        }
        catch (Exception)
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<bool> TieneSuscripcionActivaAsync(int idAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            "SELECT COUNT(*) FROM AlumnosSuscripciones WHERE IdAlumno = @IdAlumno AND Activa = 1 AND FechaVencimiento > GETDATE()",
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        var count = Convert.ToInt32(await command.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
        return count > 0;
    }

    public async Task<SuscripcionStatusDto> ObtenerDetalleSuscripcionAsync(int idAlumno, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            "SELECT TOP 1 FechaVencimiento, Activa FROM AlumnosSuscripciones WHERE IdAlumno = @IdAlumno AND Activa = 1 AND FechaVencimiento > GETDATE() ORDER BY FechaVencimiento DESC",
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        if (await reader.ReadAsync(cancellationToken))
        {
            return new SuscripcionStatusDto
            {
                Activa = Convert.ToBoolean(reader["Activa"], CultureInfo.InvariantCulture),
                FechaVencimiento = Convert.ToDateTime(reader["FechaVencimiento"], CultureInfo.InvariantCulture),
                CostoSuscripcion = 50
            };
        }

        return new SuscripcionStatusDto { Activa = false, FechaVencimiento = null, CostoSuscripcion = 50 };
    }

    public async Task<bool> SuscribirseAsync(int idAlumno, CancellationToken cancellationToken)
    {
        const decimal costo = 50m; // 50 Dracoins por suscripcion semanal

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var transaction = connection.BeginTransaction();

        try
        {
            // 1. Verificar saldo de Dracoins
            decimal saldo = 0;
            using (var checkSaldoCommand = new SqlCommand(
                "SELECT Dracoins FROM Alumnos WHERE IdAlumno = @IdAlumno",
                connection,
                transaction))
            {
                checkSaldoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                var result = await checkSaldoCommand.ExecuteScalarAsync(cancellationToken);
                if (result == null || result == DBNull.Value)
                {
                    throw new BusinessRuleException("El alumno no existe.");
                }
                saldo = Convert.ToDecimal(result, CultureInfo.InvariantCulture);
            }

            if (saldo < costo)
            {
                throw new BusinessRuleException($"Saldo insuficiente. La suscripcion cuesta {costo} Dracoins y tienes {saldo} Dracoins.");
            }

            // 2. Descontar Dracoins
            using (var updateSaldoCommand = new SqlCommand(
                "UPDATE Alumnos SET Dracoins = Dracoins - @Monto WHERE IdAlumno = @IdAlumno",
                connection,
                transaction))
            {
                updateSaldoCommand.Parameters.AddWithValue("@Monto", costo);
                updateSaldoCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await updateSaldoCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            // 3. Registrar transaccion de Dracoins
            using (var insertMovCommand = new SqlCommand(
                """
                INSERT INTO MovimientosDracoins (
                    CodigoRemitente, 
                    CodigoDestinatario, 
                    Monto, 
                    Fecha, 
                    Observacion, 
                    IdAlumnoReferencia
                ) VALUES (
                    (SELECT Codigo FROM Alumnos WHERE IdAlumno = @IdAlumno),
                    'COBRO_BIBLIOTECA',
                    @Monto,
                    GETDATE(),
                    'Suscripcion semanal a la biblioteca',
                    @IdAlumno
                )
                """,
                connection,
                transaction))
            {
                insertMovCommand.Parameters.AddWithValue("@Monto", costo);
                insertMovCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                await insertMovCommand.ExecuteNonQueryAsync(cancellationToken);
            }

            // 4. Registrar o extender suscripcion
            DateTime nuevaFechaVencimiento;
            
            // Consultar si ya tiene alguna suscripcion (incluso vencida)
            using (var checkSuscripcionCommand = new SqlCommand(
                "SELECT TOP 1 FechaVencimiento FROM AlumnosSuscripciones WHERE IdAlumno = @IdAlumno ORDER BY FechaVencimiento DESC",
                connection,
                transaction))
            {
                checkSuscripcionCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                var result = await checkSuscripcionCommand.ExecuteScalarAsync(cancellationToken);
                
                if (result != null && result != DBNull.Value)
                {
                    var vencimientoActual = Convert.ToDateTime(result, CultureInfo.InvariantCulture);
                    // Si ya vencio, se calcula desde hoy. Si sigue activa, se suma al vencimiento actual.
                    var baseDate = vencimientoActual > DateTime.Now ? vencimientoActual : DateTime.Now;
                    nuevaFechaVencimiento = baseDate.AddDays(7);

                    using var updateSuscCommand = new SqlCommand(
                        "UPDATE AlumnosSuscripciones SET FechaVencimiento = @FechaVencimiento, Activa = 1 WHERE IdAlumno = @IdAlumno",
                        connection,
                        transaction);
                    updateSuscCommand.Parameters.AddWithValue("@FechaVencimiento", nuevaFechaVencimiento);
                    updateSuscCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    await updateSuscCommand.ExecuteNonQueryAsync(cancellationToken);
                }
                else
                {
                    nuevaFechaVencimiento = DateTime.Now.AddDays(7);
                    using var insertSuscCommand = new SqlCommand(
                        "INSERT INTO AlumnosSuscripciones (IdAlumno, FechaInicio, FechaVencimiento, Activa) VALUES (@IdAlumno, GETDATE(), @FechaVencimiento, 1)",
                        connection,
                        transaction);
                    insertSuscCommand.Parameters.AddWithValue("@IdAlumno", idAlumno);
                    insertSuscCommand.Parameters.AddWithValue("@FechaVencimiento", nuevaFechaVencimiento);
                    await insertSuscCommand.ExecuteNonQueryAsync(cancellationToken);
                }
            }

            await transaction.CommitAsync(cancellationToken);
            return true;
        }
        catch (Exception)
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<bool> CrearLibroAsync(SaveLibroRequest request, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo, FechaRegistro)
            VALUES (@Titulo, @Autor, @Sinopsis, @IdCategoria, @RutaArchivo, @Formato, @PrecioDracoins, @Activo, GETDATE())
            """,
            connection);

        command.Parameters.AddWithValue("@Titulo", request.Titulo.Trim());
        command.Parameters.AddWithValue("@Autor", request.Autor.Trim());
        command.Parameters.AddWithValue("@Sinopsis", (object?)request.Sinopsis?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue("@IdCategoria", (object?)request.IdCategoria ?? DBNull.Value);
        command.Parameters.AddWithValue("@RutaArchivo", request.RutaArchivo.Trim());
        command.Parameters.AddWithValue("@Formato", request.Formato.Trim());
        command.Parameters.AddWithValue("@PrecioDracoins", request.PrecioDracoins);
        command.Parameters.AddWithValue("@Activo", request.Activo);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> ActualizarLibroAsync(int id, SaveLibroRequest request, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            UPDATE BibliotecaLibros 
            SET Titulo = @Titulo, 
                Autor = @Autor, 
                Sinopsis = @Sinopsis, 
                IdCategoria = @IdCategoria, 
                RutaArchivo = @RutaArchivo, 
                Formato = @Formato, 
                PrecioDracoins = @PrecioDracoins, 
                Activo = @Activo
            WHERE Id = @Id
            """,
            connection);

        command.Parameters.AddWithValue("@Id", id);
        command.Parameters.AddWithValue("@Titulo", request.Titulo.Trim());
        command.Parameters.AddWithValue("@Autor", request.Autor.Trim());
        command.Parameters.AddWithValue("@Sinopsis", (object?)request.Sinopsis?.Trim() ?? DBNull.Value);
        command.Parameters.AddWithValue("@IdCategoria", (object?)request.IdCategoria ?? DBNull.Value);
        command.Parameters.AddWithValue("@RutaArchivo", request.RutaArchivo.Trim());
        command.Parameters.AddWithValue("@Formato", request.Formato.Trim());
        command.Parameters.AddWithValue("@PrecioDracoins", request.PrecioDracoins);
        command.Parameters.AddWithValue("@Activo", request.Activo);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }

    public async Task<bool> EliminarLibroAsync(int id, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        // Eliminacion logica (marcar como inactivo) para no romper registros historicos de compras/progreso de lectura
        using var command = new SqlCommand(
            "UPDATE BibliotecaLibros SET Activo = 0 WHERE Id = @Id",
            connection);
        command.Parameters.AddWithValue("@Id", id);

        return await command.ExecuteNonQueryAsync(cancellationToken) > 0;
    }
}
