namespace ImperiusDraconisAPI.Configuration;

public sealed class GameOptions
{
    public const string SectionName = "Game";

    public string Version { get; set; } = "1.0.0";

    public string ApiKey { get; set; } = string.Empty;

    public int LinkCodeExpirationMinutes { get; set; } = 10;

    public string LinkCodePepper { get; set; } = string.Empty;

    public int WelcomeDracoins { get; set; } = 400;

    public int BaseDragonSlots { get; set; } = 1;

    public int MaxDragonCapacity { get; set; } = 10;
}
