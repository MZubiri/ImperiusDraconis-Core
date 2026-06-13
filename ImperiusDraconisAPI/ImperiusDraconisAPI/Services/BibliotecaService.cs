using System.Data;
using System.Globalization;
using System.IO;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Biblioteca;
using Microsoft.Data.SqlClient;
using MiniExcelLibs;

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
            "SELECT TOP 1 FechaInicio, FechaVencimiento, Activa FROM AlumnosSuscripciones WHERE IdAlumno = @IdAlumno AND Activa = 1 AND FechaVencimiento > GETDATE() ORDER BY FechaVencimiento DESC",
            connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);

        DateTime? fechaInicio = null;
        SuscripcionStatusDto? status = null;

        using (var reader = await command.ExecuteReaderAsync(cancellationToken))
        {
            if (await reader.ReadAsync(cancellationToken))
            {
                fechaInicio = Convert.ToDateTime(reader["FechaInicio"], CultureInfo.InvariantCulture);
                status = new SuscripcionStatusDto
                {
                    Activa = Convert.ToBoolean(reader["Activa"], CultureInfo.InvariantCulture),
                    FechaVencimiento = Convert.ToDateTime(reader["FechaVencimiento"], CultureInfo.InvariantCulture),
                    CostoSuscripcion = 250,
                    DescargasPermitidas = 2
                };
            }
        }

        if (status != null && fechaInicio.HasValue)
        {
            // Contar descargas de libros únicos realizadas durante este periodo de suscripción
            using var countCmd = new SqlCommand(
                "SELECT COUNT(DISTINCT IdLibro) FROM AlumnosLibrosDescargados WHERE IdAlumno = @IdAlumno AND FechaDescarga >= @FechaInicio",
                connection);
            countCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
            countCmd.Parameters.AddWithValue("@FechaInicio", fechaInicio.Value);
            status.DescargasRealizadas = Convert.ToInt32(await countCmd.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
            return status;
        }

        return new SuscripcionStatusDto 
        { 
            Activa = false, 
            FechaVencimiento = null, 
            CostoSuscripcion = 250,
            DescargasRealizadas = 0,
            DescargasPermitidas = 2
        };
    }

    public async Task<bool> SuscribirseAsync(int idAlumno, CancellationToken cancellationToken)
    {
        const decimal costo = 250m; // 250 Dracoins por suscripcion semanal

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

    public async Task<byte[]> ExportarLibrosExcelAsync(CancellationToken cancellationToken)
    {
        var rows = new List<BookExcelRow>();
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        using var command = new SqlCommand(
            """
            SELECT 
                L.Id, 
                L.Titulo, 
                L.Autor, 
                L.Sinopsis, 
                C.Nombre AS Categoria, 
                L.RutaArchivo, 
                L.Formato, 
                L.PrecioDracoins, 
                L.Activo
            FROM BibliotecaLibros L
            LEFT JOIN BibliotecaCategorias C ON C.Id = L.IdCategoria
            ORDER BY L.Id
            """, connection);

        using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            rows.Add(new BookExcelRow
            {
                Id = Convert.ToInt32(reader["Id"], CultureInfo.InvariantCulture),
                Titulo = reader["Titulo"]?.ToString() ?? string.Empty,
                Autor = reader["Autor"]?.ToString() ?? string.Empty,
                Sinopsis = reader["Sinopsis"] == DBNull.Value ? null : reader["Sinopsis"]?.ToString(),
                Categoria = reader["Categoria"] == DBNull.Value ? null : reader["Categoria"]?.ToString(),
                RutaArchivo = reader["RutaArchivo"]?.ToString() ?? string.Empty,
                Formato = reader["Formato"]?.ToString() ?? string.Empty,
                PrecioDracoins = Convert.ToDecimal(reader["PrecioDracoins"], CultureInfo.InvariantCulture),
                Activo = Convert.ToBoolean(reader["Activo"], CultureInfo.InvariantCulture)
            });
        }

        using var memoryStream = new MemoryStream();
        memoryStream.SaveAs(rows);
        return memoryStream.ToArray();
    }

    public async Task<int> ImportarLibrosExcelAsync(Stream excelStream, CancellationToken cancellationToken)
    {
        var rows = excelStream.Query<BookExcelRow>().ToList();
        if (rows.Count == 0) return 0;

        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        // 1. Obtener todas las categorias existentes para mapeo rapido, o crearlas si no existen
        var categoriasMap = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        using (var catCmd = new SqlCommand("SELECT Id, Nombre FROM BibliotecaCategorias", connection))
        using (var catReader = await catCmd.ExecuteReaderAsync(cancellationToken))
        {
            while (await catReader.ReadAsync(cancellationToken))
            {
                var id = Convert.ToInt32(catReader["Id"], CultureInfo.InvariantCulture);
                var nombre = catReader["Nombre"]?.ToString()?.Trim() ?? string.Empty;
                if (!string.IsNullOrEmpty(nombre) && !categoriasMap.ContainsKey(nombre))
                {
                    categoriasMap.Add(nombre, id);
                }
            }
        }

        int importados = 0;
        foreach (var row in rows)
        {
            if (string.IsNullOrWhiteSpace(row.Titulo) || string.IsNullOrWhiteSpace(row.Autor))
            {
                continue; // Saltar filas sin datos criticos
            }

            // Mapear o crear la categoria si viene especificada
            int? idCategoria = null;
            if (!string.IsNullOrWhiteSpace(row.Categoria))
            {
                var catNombre = row.Categoria.Trim();
                if (categoriasMap.TryGetValue(catNombre, out var catId))
                {
                    idCategoria = catId;
                }
                else
                {
                    // Crear categoria nueva en caliente
                    using var insertCatCmd = new SqlCommand(
                        "INSERT INTO BibliotecaCategorias (Nombre, Descripcion, Activo) OUTPUT INSERTED.Id VALUES (@Nombre, @Descripcion, 1)",
                        connection);
                    insertCatCmd.Parameters.AddWithValue("@Nombre", catNombre);
                    insertCatCmd.Parameters.AddWithValue("@Descripcion", $"Categoria creada en importacion");
                    var newId = (int?)await insertCatCmd.ExecuteScalarAsync(cancellationToken);
                    if (newId.HasValue)
                    {
                        categoriasMap.Add(catNombre, newId.Value);
                        idCategoria = newId.Value;
                    }
                }
            }

            // Si viene un ID y existe en la BD, actualizamos. De lo contrario, insertamos.
            bool existe = false;
            if (row.Id.HasValue && row.Id.Value > 0)
            {
                using var checkCmd = new SqlCommand("SELECT COUNT(*) FROM BibliotecaLibros WHERE Id = @Id", connection);
                checkCmd.Parameters.AddWithValue("@Id", row.Id.Value);
                var count = Convert.ToInt32(await checkCmd.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
                existe = count > 0;
            }

            if (existe)
            {
                // Actualizar
                using var updateCmd = new SqlCommand(
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
                    """, connection);

                updateCmd.Parameters.AddWithValue("@Id", row.Id!.Value);
                updateCmd.Parameters.AddWithValue("@Titulo", row.Titulo.Trim());
                updateCmd.Parameters.AddWithValue("@Autor", row.Autor.Trim());
                updateCmd.Parameters.AddWithValue("@Sinopsis", (object?)row.Sinopsis?.Trim() ?? DBNull.Value);
                updateCmd.Parameters.AddWithValue("@IdCategoria", (object?)idCategoria ?? DBNull.Value);
                updateCmd.Parameters.AddWithValue("@RutaArchivo", string.IsNullOrWhiteSpace(row.RutaArchivo) ? "Libros/PDF/" : row.RutaArchivo.Trim());
                updateCmd.Parameters.AddWithValue("@Formato", string.IsNullOrWhiteSpace(row.Formato) ? ".pdf" : row.Formato.Trim());
                updateCmd.Parameters.AddWithValue("@PrecioDracoins", row.PrecioDracoins);
                updateCmd.Parameters.AddWithValue("@Activo", row.Activo ? 1 : 0);

                await updateCmd.ExecuteNonQueryAsync(cancellationToken);
            }
            else
            {
                // Insertar
                using var insertCmd = new SqlCommand(
                    """
                    INSERT INTO BibliotecaLibros (Titulo, Autor, Sinopsis, IdCategoria, RutaArchivo, Formato, PrecioDracoins, Activo, FechaRegistro)
                    VALUES (@Titulo, @Autor, @Sinopsis, @IdCategoria, @RutaArchivo, @Formato, @PrecioDracoins, @Activo, GETDATE())
                    """, connection);

                insertCmd.Parameters.AddWithValue("@Titulo", row.Titulo.Trim());
                insertCmd.Parameters.AddWithValue("@Autor", row.Autor.Trim());
                insertCmd.Parameters.AddWithValue("@Sinopsis", (object?)row.Sinopsis?.Trim() ?? DBNull.Value);
                insertCmd.Parameters.AddWithValue("@IdCategoria", (object?)idCategoria ?? DBNull.Value);
                insertCmd.Parameters.AddWithValue("@RutaArchivo", string.IsNullOrWhiteSpace(row.RutaArchivo) ? "Libros/PDF/" : row.RutaArchivo.Trim());
                insertCmd.Parameters.AddWithValue("@Formato", string.IsNullOrWhiteSpace(row.Formato) ? ".pdf" : row.Formato.Trim());
                insertCmd.Parameters.AddWithValue("@PrecioDracoins", row.PrecioDracoins);
                insertCmd.Parameters.AddWithValue("@Activo", row.Activo ? 1 : 0);

                await insertCmd.ExecuteNonQueryAsync(cancellationToken);
            }

            importados++;
        }

        return importados;
    }

    public async Task<bool> ValidarAccesoLecturaAsync(int idAlumno, int idLibro, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        // 1. Si el libro tiene costo 0, es gratis para todos
        using var checkCostoCmd = new SqlCommand(
            "SELECT PrecioDracoins FROM BibliotecaLibros WHERE Id = @IdLibro AND Activo = 1",
            connection);
        checkCostoCmd.Parameters.AddWithValue("@IdLibro", idLibro);
        var resultCosto = await checkCostoCmd.ExecuteScalarAsync(cancellationToken);
        if (resultCosto == null || resultCosto == DBNull.Value) return false;
        var precio = Convert.ToDecimal(resultCosto, CultureInfo.InvariantCulture);
        if (precio == 0) return true;

        // 2. Verificar si tiene suscripcion activa
        var tieneSuscripcion = await TieneSuscripcionActivaAsync(idAlumno, cancellationToken);
        if (tieneSuscripcion) return true;

        // 3. Verificar si lo ha comprado individualmente
        using var checkCompraCmd = new SqlCommand(
            "SELECT COUNT(*) FROM AlumnosLibrosComprados WHERE IdAlumno = @IdAlumno AND IdLibro = @IdLibro",
            connection);
        checkCompraCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
        checkCompraCmd.Parameters.AddWithValue("@IdLibro", idLibro);
        var countCompra = Convert.ToInt32(await checkCompraCmd.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);
        return countCompra > 0;
    }

    public async Task<(bool success, string message)> RegistrarDescargaSubscripcionAsync(int idAlumno, int idLibro, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        // 1. Obtener la suscripción activa actual
        using var checkSubCmd = new SqlCommand(
            "SELECT TOP 1 FechaInicio FROM AlumnosSuscripciones WHERE IdAlumno = @IdAlumno AND Activa = 1 AND FechaVencimiento > GETDATE() ORDER BY FechaVencimiento DESC",
            connection);
        checkSubCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
        var fechaInicioObj = await checkSubCmd.ExecuteScalarAsync(cancellationToken);
        if (fechaInicioObj == null || fechaInicioObj == DBNull.Value)
        {
            return (false, "No tienes una suscripción activa.");
        }
        var fechaInicio = Convert.ToDateTime(fechaInicioObj, CultureInfo.InvariantCulture);

        // 2. Verificar si ya descargó ESTE libro en la semana actual
        using var checkEsteLibroCmd = new SqlCommand(
            "SELECT COUNT(*) FROM AlumnosLibrosDescargados WHERE IdAlumno = @IdAlumno AND IdLibro = @IdLibro AND FechaDescarga >= @FechaInicio",
            connection);
        checkEsteLibroCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
        checkEsteLibroCmd.Parameters.AddWithValue("@IdLibro", idLibro);
        checkEsteLibroCmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
        var yaDescargado = Convert.ToInt32(await checkEsteLibroCmd.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;

        if (yaDescargado)
        {
            // Permitir descargar de nuevo sin descontar crédito
            return (true, "Re-descarga permitida.");
        }

        // 3. Contar cuántos libros ÚNICOS ha descargado ya esta semana
        using var countCmd = new SqlCommand(
            "SELECT COUNT(DISTINCT IdLibro) FROM AlumnosLibrosDescargados WHERE IdAlumno = @IdAlumno AND FechaDescarga >= @FechaInicio",
            connection);
        countCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
        countCmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
        var totalDescargados = Convert.ToInt32(await countCmd.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture);

        if (totalDescargados >= 2)
        {
            return (false, "Has alcanzado el límite de 2 descargas semanales de tu suscripción. Puedes adquirir el libro de forma individual por 300 Dracoins para descargas ilimitadas.");
        }

        // 4. Registrar la descarga
        using var insertCmd = new SqlCommand(
            "INSERT INTO AlumnosLibrosDescargados (IdAlumno, IdLibro) VALUES (@IdAlumno, @IdLibro)",
            connection);
        insertCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
        insertCmd.Parameters.AddWithValue("@IdLibro", idLibro);
        await insertCmd.ExecuteNonQueryAsync(cancellationToken);

        return (true, "Descarga registrada con éxito.");
    }

    public async Task<(bool success, string message, string? relativePath)> ValidarYObtenerRutaDescargaAsync(int idAlumno, int idLibro, bool esAdmin, CancellationToken cancellationToken)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);

        // 1. Obtener la ruta y costo del libro
        using var checkLibroCmd = new SqlCommand(
            "SELECT RutaArchivo, PrecioDracoins FROM BibliotecaLibros WHERE Id = @IdLibro AND Activo = 1",
            connection);
        checkLibroCmd.Parameters.AddWithValue("@IdLibro", idLibro);

        string? rutaRelativa = null;
        decimal precio = 0;

        using (var reader = await checkLibroCmd.ExecuteReaderAsync(cancellationToken))
        {
            if (await reader.ReadAsync(cancellationToken))
            {
                rutaRelativa = reader["RutaArchivo"]?.ToString();
                precio = Convert.ToDecimal(reader["PrecioDracoins"], CultureInfo.InvariantCulture);
            }
        }

        if (string.IsNullOrWhiteSpace(rutaRelativa))
        {
            return (false, "El libro no existe o no está activo.", null);
        }

        // 2. Si es admin o el libro es gratis (precio == 0), permitir descarga directa
        if (esAdmin || precio == 0)
        {
            return (true, "Descarga permitida.", rutaRelativa);
        }

        // 3. Verificar si el usuario lo compró
        using var checkCompraCmd = new SqlCommand(
            "SELECT COUNT(*) FROM AlumnosLibrosComprados WHERE IdAlumno = @IdAlumno AND IdLibro = @IdLibro",
            connection);
        checkCompraCmd.Parameters.AddWithValue("@IdAlumno", idAlumno);
        checkCompraCmd.Parameters.AddWithValue("@IdLibro", idLibro);
        var comprado = Convert.ToInt32(await checkCompraCmd.ExecuteScalarAsync(cancellationToken), CultureInfo.InvariantCulture) > 0;

        if (comprado)
        {
            return (true, "Descarga permitida.", rutaRelativa);
        }

        // 4. Si no lo compró, verificar si tiene suscripción y procesar
        var (descargaValida, msgDescarga) = await RegistrarDescargaSubscripcionAsync(idAlumno, idLibro, cancellationToken);
        if (!descargaValida)
        {
            return (false, msgDescarga, null);
        }

        return (true, "Descarga permitida.", rutaRelativa);
    }
}
