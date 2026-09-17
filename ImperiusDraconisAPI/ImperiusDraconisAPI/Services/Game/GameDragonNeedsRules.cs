namespace ImperiusDraconisAPI.Services.Game;

internal static class GameDragonNeedsRules
{
    public static DragonNeedsState ApplyDecay(
        int life,
        int happiness,
        int hunger,
        DateTime lastUpdateAt,
        DateTime utcNow,
        int hungerDecayModifierPct = 0)
    {
        var elapsed = utcNow - lastUpdateAt;
        if (elapsed <= TimeSpan.Zero)
        {
            return new DragonNeedsState(life, happiness, hunger, life == 0 ? "FLED" : "ACTIVE");
        }

        var baseHungerLoss = (int)Math.Floor(elapsed.TotalHours / 2d);
        var hungerLoss = (int)Math.Floor(baseHungerLoss * (1 + hungerDecayModifierPct / 100d));
        var nextHunger = Math.Clamp(hunger - hungerLoss, 0, 100);
        var happinessLoss = nextHunger < 30 ? (int)Math.Floor(elapsed.TotalHours / 4d) : 0;
        var nextHappiness = Math.Clamp(happiness - happinessLoss, 0, 100);
        var lifeLoss = nextHappiness < 20 ? (int)Math.Floor(elapsed.TotalHours / 6d) : 0;
        var nextLife = Math.Clamp(life - lifeLoss, 0, 100);
        return new DragonNeedsState(nextLife, nextHappiness, nextHunger, nextLife == 0 ? "FLED" : "ACTIVE");
    }

    public static (int Level, string Stage) CalculateProgress(
        int experience,
        DateTime hatchedAt,
        DateTime utcNow,
        int life = 100,
        int happiness = 100)
    {
        var level = Math.Clamp(1 + experience / 25, 1, 20);
        var age = utcNow - hatchedAt;
        var stage = age >= TimeSpan.FromHours(96) && experience >= 250 && life >= 60 && happiness >= 40
            ? "ADULT"
            : age >= TimeSpan.FromHours(24) && experience >= 80 && life >= 50 && happiness >= 30
                ? "YOUNG"
                : "BABY";
        return (level, stage);
    }
}

internal sealed record DragonNeedsState(int Life, int Happiness, int Hunger, string Status);
