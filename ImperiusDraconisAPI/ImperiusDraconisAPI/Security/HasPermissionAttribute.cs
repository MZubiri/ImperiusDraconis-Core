using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace ImperiusDraconisAPI.Security;

[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
public sealed class HasPermissionAttribute(params string[] permissions) : Attribute, IAuthorizationFilter
{
    private readonly string[] _permissions = permissions;

    public void OnAuthorization(AuthorizationFilterContext context)
    {
        var user = context.HttpContext.User;
        if (user.Identity?.IsAuthenticated != true)
        {
            context.Result = new UnauthorizedResult();
            return;
        }

        var hasPermission = user.Claims.Any(claim =>
            claim.Type == "permission" &&
            _permissions.Any(permission =>
                string.Equals(claim.Value, permission, StringComparison.OrdinalIgnoreCase)));

        if (!hasPermission)
        {
            context.Result = new ForbidResult();
        }
    }
}
