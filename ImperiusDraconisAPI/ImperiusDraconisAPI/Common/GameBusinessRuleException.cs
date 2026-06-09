namespace ImperiusDraconisAPI.Common;

public sealed class GameBusinessRuleException : Exception
{
    public GameBusinessRuleException(string code, string message, int statusCode = StatusCodes.Status409Conflict)
        : base(message)
    {
        Code = code;
        StatusCode = statusCode;
    }

    public string Code { get; }

    public int StatusCode { get; }
}
