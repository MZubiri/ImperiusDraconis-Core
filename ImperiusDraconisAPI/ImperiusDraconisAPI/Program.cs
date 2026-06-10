using System.Text;
using ImperiusDraconisAPI.Configuration;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Security;
using ImperiusDraconisAPI.Services;
using ImperiusDraconisAPI.Services.Game;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<JwtOptions>(builder.Configuration.GetSection(JwtOptions.SectionName));
builder.Services.Configure<SmtpOptions>(builder.Configuration.GetSection(SmtpOptions.SectionName));
builder.Services.Configure<AuthRecoveryOptions>(builder.Configuration.GetSection(AuthRecoveryOptions.SectionName));
builder.Services.Configure<GameOptions>(builder.Configuration.GetSection(GameOptions.SectionName));
builder.Services.AddSingleton<SqlConnectionFactory>();
builder.Services.AddSingleton<LegacyAssetStorage>();
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<AlumnosService>();
builder.Services.AddScoped<DracoinsService>();
builder.Services.AddScoped<MarcadoresService>();
builder.Services.AddScoped<DinamicasService>();
builder.Services.AddSingleton<AutomaticHousePointsService>();
builder.Services.AddSingleton<AutomaticDracoinsCounterService>();
builder.Services.AddScoped<GeminiFormatCorrectionService>();
builder.Services.AddScoped<MascotasService>();
builder.Services.AddScoped<ChismesService>();
builder.Services.AddScoped<PermisosService>();
builder.Services.AddScoped<ProductosService>();
builder.Services.AddScoped<TrabajosService>();
builder.Services.AddScoped<TiendaService>();
builder.Services.AddScoped<RinconService>();
builder.Services.AddScoped<UserPreferencesService>();
builder.Services.AddScoped<GameIdempotencyService>();
builder.Services.AddScoped<DracoinGameService>();
builder.Services.AddScoped<GameLinkService>();
builder.Services.AddScoped<GameEggService>();
builder.Services.AddScoped<GamePlayerService>();
builder.Services.AddScoped<GameDragonService>();


builder.Services.AddHttpClient();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Imperius Draconis API",
        Version = "v1",
        Description = "API base para migrar la logica del proyecto legado a Angular + ASP.NET Core."
    });

    var bearerSecurityScheme = new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Reference = new OpenApiReference
        {
            Type = ReferenceType.SecurityScheme,
            Id = JwtBearerDefaults.AuthenticationScheme
        }
    };

    options.AddSecurityDefinition(bearerSecurityScheme.Reference.Id, bearerSecurityScheme);
    options.AddSecurityDefinition(
        GameApiKeyAuthenticationDefaults.AuthenticationScheme,
        new OpenApiSecurityScheme
        {
            Name = GameApiKeyAuthenticationDefaults.HeaderName,
            Type = SecuritySchemeType.ApiKey,
            In = ParameterLocation.Header,
            Description = "API Key para llamadas servidor Roblox a Imperius."
        });
    options.OperationFilter<AuthorizeOperationFilter>();

    options.IncludeXmlComments(Path.Combine(
        AppContext.BaseDirectory,
        "ImperiusDraconisAPI.xml"));
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AngularDevClient", policy =>
    {
        var origins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>();
        if (origins is { Length: > 0 })
        {
            policy.WithOrigins(origins).AllowAnyHeader().AllowAnyMethod();
            return;
        }

        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

var jwtSection = builder.Configuration.GetSection(JwtOptions.SectionName);
var issuer = jwtSection["Issuer"];
var audience = jwtSection["Audience"];
var secretKey = jwtSection["SecretKey"];

if (string.IsNullOrWhiteSpace(secretKey))
{
    throw new InvalidOperationException("Falta configurar Jwt:SecretKey en appsettings.");
}

builder.Services
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = issuer,
            ValidateAudience = true,
            ValidAudience = audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)),
            ValidateLifetime = true,
            ClockSkew = TimeSpan.FromMinutes(2)
        };
    })
    .AddScheme<AuthenticationSchemeOptions, GameApiKeyAuthenticationHandler>(
        GameApiKeyAuthenticationDefaults.AuthenticationScheme,
        _ => { });

builder.Services.AddAuthorization();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseStaticFiles();
app.UseHttpsRedirection();
app.UseCors("AngularDevClient");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
