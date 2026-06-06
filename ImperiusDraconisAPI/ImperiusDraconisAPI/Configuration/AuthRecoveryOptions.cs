namespace ImperiusDraconisAPI.Configuration;

public sealed class AuthRecoveryOptions
{
    public const string SectionName = "AuthRecovery";

    public bool ExposeTemporaryPasswordInDevelopment { get; set; }
}
