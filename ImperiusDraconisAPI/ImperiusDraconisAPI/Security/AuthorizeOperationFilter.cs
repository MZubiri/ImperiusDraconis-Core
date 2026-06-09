using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace ImperiusDraconisAPI.Security;

public sealed class AuthorizeOperationFilter : IOperationFilter
{
    public void Apply(OpenApiOperation operation, OperationFilterContext context)
    {
        var authorizeAttributes = context.MethodInfo
            .GetCustomAttributes(true)
            .OfType<AuthorizeAttribute>()
            .Concat(context.MethodInfo.DeclaringType?
                .GetCustomAttributes(true)
                .OfType<AuthorizeAttribute>()
                ?? []);

        var schemes = authorizeAttributes
            .SelectMany(attribute => (attribute.AuthenticationSchemes ?? string.Empty)
                .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            .ToArray();

        if (!authorizeAttributes.Any())
        {
            return;
        }

        var schemeId = schemes.Contains(
            GameApiKeyAuthenticationDefaults.AuthenticationScheme,
            StringComparer.Ordinal)
            ? GameApiKeyAuthenticationDefaults.AuthenticationScheme
            : JwtBearerDefaults.AuthenticationScheme;

        operation.Security =
        [
            new OpenApiSecurityRequirement
            {
                [
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = schemeId
                        }
                    }
                ] = Array.Empty<string>()
            }
        ];
    }
}
