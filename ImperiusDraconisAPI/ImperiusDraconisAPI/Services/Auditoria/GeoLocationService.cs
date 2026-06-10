using System;
using System.Net;
using MaxMind.GeoIP2;
using MaxMind.GeoIP2.Exceptions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ImperiusDraconisAPI.Services.Auditoria
{
    public interface IGeoLocationService
    {
        (string? Pais, string? Ciudad, string? ISP) ObtenerMetadatosIp(string ipAddress);
    }

    public class GeoLocationService : IGeoLocationService
    {
        private readonly DatabaseReader? _cityReader;
        private readonly DatabaseReader? _asnReader;
        private readonly ILogger<GeoLocationService> _logger;

        public GeoLocationService(IConfiguration configuration, ILogger<GeoLocationService> logger)
        {
            _logger = logger;
            try
            {
                // Rutas configurables en appsettings o rutas por defecto en la VM de Oracle
                string cityPath = configuration["MaxMind:CityDatabasePath"] ?? "/var/lib/GeoIP/GeoLite2-City.mmdb";
                string asnPath = configuration["MaxMind:AsnDatabasePath"] ?? "/var/lib/GeoIP/GeoLite2-ASN.mmdb";

                if (System.IO.File.Exists(cityPath))
                {
                    _cityReader = new DatabaseReader(cityPath);
                    _logger.LogInformation("Lector de MaxMind GeoLite2 City cargado exitosamente desde: {Path}", cityPath);
                }
                else
                {
                    _logger.LogWarning("Base de datos GeoLite2 City no encontrada en: {Path}", cityPath);
                }

                if (System.IO.File.Exists(asnPath))
                {
                    _asnReader = new DatabaseReader(asnPath);
                    _logger.LogInformation("Lector de MaxMind GeoLite2 ASN cargado exitosamente desde: {Path}", asnPath);
                }
                else
                {
                    _logger.LogWarning("Base de datos GeoLite2 ASN no encontrada en: {Path}", asnPath);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al inicializar los lectores de MaxMind GeoLite2");
            }
        }

        public (string? Pais, string? Ciudad, string? ISP) ObtenerMetadatosIp(string ipAddress)
        {
            string? pais = null;
            string? ciudad = null;
            string? isp = null;

            try
            {
                if (string.IsNullOrWhiteSpace(ipAddress)) return (null, null, null);

                if (!IPAddress.TryParse(ipAddress.Trim(), out var ip))
                {
                    return (null, null, null);
                }

                if (ip.IsIPv4MappedToIPv6)
                {
                    ip = ip.MapToIPv4();
                }

                // Omitir IPs locales y de red privada para evitar excepciones en MaxMind DatabaseReader
                if (IPAddress.IsLoopback(ip) || EsIpPrivada(ip))
                {
                    return ("LOCAL", "Red Local", "Red Privada / Intranet");
                }

                // 1. Resolver País y Ciudad
                if (_cityReader != null)
                {
                    try
                    {
                        var cityResponse = _cityReader.City(ip);
                        pais = cityResponse.Country.IsoCode;
                        ciudad = cityResponse.City.Name;
                    }
                    catch (AddressNotFoundException)
                    {
                        pais = "Desconocido";
                        ciudad = "Desconocido";
                    }
                }

                // 2. Resolver ASN / ISP
                if (_asnReader != null)
                {
                    try
                    {
                        var asnResponse = _asnReader.Asn(ip);
                        isp = asnResponse.AutonomousSystemOrganization;
                    }
                    catch (AddressNotFoundException)
                    {
                        isp = "Proveedor Desconocido";
                    }
                }
            }
            catch (Exception ex)
            {
                // Fallback silencioso: Registramos el error en logs pero no alteramos el flujo de ejecución principal
                _logger.LogError(ex, "Fallo no crítico al resolver metadatos de IP para: {IP}", ipAddress);
            }

            return (pais, ciudad, isp);
        }

        private bool EsIpPrivada(IPAddress ip)
        {
            if (ip.IsIPv4MappedToIPv6)
            {
                ip = ip.MapToIPv4();
            }

            byte[] bytes = ip.GetAddressBytes();
            if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
            {
                // Rangos de red privada RFC 1918
                if (bytes[0] == 10) return true;
                if (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) return true;
                if (bytes[0] == 192 && bytes[1] == 168) return true;
            }
            return false;
        }
    }
}
