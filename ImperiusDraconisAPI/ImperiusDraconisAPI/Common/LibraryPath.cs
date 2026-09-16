namespace ImperiusDraconisAPI.Common;

public static class LibraryPath
{
    public static bool IsWithin(string baseDirectory, string candidate)
    {
        try
        {
            var root = Path.GetFullPath(baseDirectory).TrimEnd(Path.DirectorySeparatorChar)
                + Path.DirectorySeparatorChar;
            var path = Path.GetFullPath(candidate);
            var comparison = OperatingSystem.IsWindows()
                ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal;
            return path.StartsWith(root, comparison);
        }
        catch (Exception ex) when (ex is ArgumentException or NotSupportedException or PathTooLongException)
        {
            return false;
        }
    }
}
