using Microsoft.Data.SqlClient;

namespace ImperiusDraconisAPI.Data;

public sealed class SqlConnectionFactory
{
    private readonly string _connectionString;

    public SqlConnectionFactory(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection") ?? string.Empty;

        if (string.IsNullOrWhiteSpace(_connectionString))
        {
            throw new InvalidOperationException(
                "Falta configurar ConnectionStrings__DefaultConnection.");
        }
    }

    public SqlConnection CreateConnection() => new(_connectionString);
}
