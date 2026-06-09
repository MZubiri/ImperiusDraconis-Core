namespace ImperiusDraconisAPI.Common;

public sealed class GameBusinessRuleException : Exception
{
    public GameBusinessRuleException(string code, string message)
        : base(message)
    {
        Code = code;
    }

    public string Code { get; }
}
