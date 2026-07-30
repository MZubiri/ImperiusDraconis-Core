using MySqlConnector;

namespace ImperiusDraconisAPI.Data;

public sealed class MySqlConnectionFactory
{
    private readonly string _connectionString;

    public MySqlConnectionFactory(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection") ?? string.Empty;

        if (string.IsNullOrWhiteSpace(_connectionString))
        {
            throw new InvalidOperationException(
                "Falta configurar ConnectionStrings__DefaultConnection.");
        }
    }

    public MySqlConnection CreateConnection() => new(_connectionString);
}
