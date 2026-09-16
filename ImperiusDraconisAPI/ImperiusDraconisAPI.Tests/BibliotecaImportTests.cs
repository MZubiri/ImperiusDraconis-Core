using System.Diagnostics;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Biblioteca;
using ImperiusDraconisAPI.Services;
using Microsoft.Extensions.Configuration;
using MiniExcelLibs;
using MySqlConnector;
using Xunit;

public sealed class BibliotecaImportTests
{
    [MySqlIntegrationFact]
    public async Task ImportsOver100RowsAndRollsBackAllBatchesOnFailure()
    {
        var builder = new MySqlConnectionStringBuilder(Environment.GetEnvironmentVariable("ID_TEST_MYSQL")!);
        Assert.Equal("remediation_auth", builder.Database);
        builder.Database = "remediation_bulk";
        await using var connection = new MySqlConnection(builder.ConnectionString);
        await connection.OpenAsync();
        await using var command = new MySqlCommand("""
            CREATE TABLE IF NOT EXISTS BibliotecaCategorias (
                Id INT AUTO_INCREMENT PRIMARY KEY, Nombre VARCHAR(255), Descripcion TEXT, Activo TINYINT);
            CREATE TABLE IF NOT EXISTS BibliotecaLibros (
                Id INT AUTO_INCREMENT PRIMARY KEY, Titulo VARCHAR(255) NOT NULL, Autor VARCHAR(255), Sinopsis TEXT,
                IdCategoria INT NULL, RutaArchivo VARCHAR(2048), Formato VARCHAR(50), PrecioDracoins DECIMAL(18,2),
                Activo TINYINT, FechaRegistro DATETIME);
            DELETE FROM BibliotecaLibros;
            DELETE FROM BibliotecaCategorias;
            """, connection);
        await command.ExecuteNonQueryAsync();
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["ConnectionStrings:DefaultConnection"] = builder.ConnectionString
        }).Build();
        var service = new BibliotecaService(new MySqlConnectionFactory(config), null!);
        var rows = Enumerable.Range(1, 205).Select(i => new BookExcelRow
        {
            Titulo = $"Libro {i}", Autor = "Autor", Categoria = "Nueva", Activo = true, PrecioDracoins = i
        }).ToList();
        async Task<int> Import(List<BookExcelRow> input)
        {
            using var excel = new MemoryStream();
            excel.SaveAs(input);
            excel.Position = 0;
            return await service.ImportarLibrosExcelAsync(excel, default);
        }
        var timer = Stopwatch.StartNew();
        Assert.Equal(205, await Import(rows));
        timer.Stop();
        Assert.True(timer.Elapsed < TimeSpan.FromSeconds(30), $"Import took {timer.Elapsed}");
        command.CommandText = "SELECT COUNT(*) FROM BibliotecaLibros;";
        Assert.Equal(205, Convert.ToInt32(await command.ExecuteScalarAsync()));
        command.CommandText = "SELECT MIN(Id) FROM BibliotecaLibros;";
        var existingId = Convert.ToInt32(await command.ExecuteScalarAsync());
        Assert.Equal(2, await Import(new List<BookExcelRow> {
            new() { Id = existingId, Titulo = "Actualizado", Autor = "Autor", Categoria = "nueva" },
            new() { Id = int.MaxValue, Titulo = "Nuevo", Autor = "Autor" }
        }));
        command.CommandText = "SELECT COUNT(*) FROM BibliotecaCategorias;";
        Assert.Equal(1, Convert.ToInt32(await command.ExecuteScalarAsync()));
        rows[0].Id = existingId;
        rows[0].Titulo = "No debe persistir";
        rows[0].Categoria = "Rollback";
        rows[^1].Titulo = new string('x', 300);
        await Assert.ThrowsAsync<MySqlException>(() => Import(rows));
        command.CommandText = "SELECT COUNT(*) FROM BibliotecaLibros;";
        Assert.Equal(206, Convert.ToInt32(await command.ExecuteScalarAsync()));
        command.CommandText = $"SELECT Titulo FROM BibliotecaLibros WHERE Id = {existingId};";
        Assert.Equal("Actualizado", await command.ExecuteScalarAsync());
        command.CommandText = "SELECT COUNT(*) FROM BibliotecaCategorias;";
        Assert.Equal(1, Convert.ToInt32(await command.ExecuteScalarAsync()));
    }
}
