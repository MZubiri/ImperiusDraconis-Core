FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ImperiusDraconisAPI.csproj ./
RUN dotnet restore ImperiusDraconisAPI.csproj

COPY . ./
RUN dotnet publish ImperiusDraconisAPI.csproj \
    --configuration Release \
    --output /app/publish \
    --no-restore \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /app/publish ./
RUN mkdir -p wwwroot_backup && [ -d wwwroot/Content ] && cp -R wwwroot/Content wwwroot_backup/ || true

ENTRYPOINT ["dotnet", "ImperiusDraconisAPI.dll"]
