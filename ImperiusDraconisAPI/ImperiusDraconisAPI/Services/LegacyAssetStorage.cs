using ImperiusDraconisAPI.Common;
using Microsoft.AspNetCore.Http;

namespace ImperiusDraconisAPI.Services;

public sealed class LegacyAssetStorage
{
    private static readonly HashSet<string> AllowedImageExtensions =
        new([".jpg", ".jpeg", ".png", ".gif", ".webp"], StringComparer.OrdinalIgnoreCase);

    private readonly IWebHostEnvironment _environment;

    public LegacyAssetStorage(IWebHostEnvironment environment)
    {
        _environment = environment;
    }

    public async Task<string> SaveImageAsync(
        IFormFile file,
        string relativeFolder,
        CancellationToken cancellationToken)
    {
        if (file is null || file.Length <= 0)
        {
            throw new BusinessRuleException("Debes adjuntar una imagen valida.");
        }

        var extension = Path.GetExtension(file.FileName)?.Trim() ?? string.Empty;
        if (!AllowedImageExtensions.Contains(extension))
        {
            throw new BusinessRuleException("Solo se permiten imagenes JPG, PNG, GIF o WEBP.");
        }

        var folderSegments = relativeFolder
            .Split(['/', '\\'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        var absoluteFolder = Path.Combine(
            _environment.WebRootPath ?? Path.Combine(_environment.ContentRootPath, "wwwroot"),
            Path.Combine(folderSegments));

        Directory.CreateDirectory(absoluteFolder);

        var fileName = $"{Guid.NewGuid():N}{extension.ToLowerInvariant()}";
        var absolutePath = Path.Combine(absoluteFolder, fileName);

        await using (var stream = File.Create(absolutePath))
        {
            await file.CopyToAsync(stream, cancellationToken);
        }

        return "/" + string.Join("/", folderSegments.Append(fileName));
    }
}
