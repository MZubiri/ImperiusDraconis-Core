using ImperiusDraconisAPI.Common;
using Xunit;

public sealed class LibraryPathTests
{
    [Theory]
    [InlineData("Libros/book.pdf", true)]
    [InlineData("../secret.txt", false)]
    [InlineData("../Biblioteca-private/secret.txt", false)]
    [InlineData("Libros/../../secret.txt", false)]
    [InlineData(".", false)]
    public void ValidatesDirectoryBoundary(string relative, bool allowed)
    {
        var root = Path.Combine(Path.GetTempPath(), "Biblioteca");
        Assert.Equal(allowed, LibraryPath.IsWithin(root, Path.Combine(root, relative)));
    }

    [Fact]
    public void RespectsCaseSensitiveFileSystems()
    {
        if (OperatingSystem.IsWindows()) return;
        Assert.False(LibraryPath.IsWithin("/tmp/Biblioteca", "/tmp/biblioteca/book.pdf"));
    }
}
