# Imperius Draconis - Core 🐉

Ecosistema central de lógica de negocio, persistencia e integración backend para **Imperius Draconis**, que da soporte tanto al portal web de usuarios como a la sincronización en tiempo real del juego en **Roblox**.

El proyecto nace de la necesidad de migrar la antigua plataforma monolítica de ASP.NET hacia una arquitectura moderna dockerizada desplegada en una VPS Linux para lograr autonomía total de infraestructura y reducir costos operativos.

---

## 🚀 Características Principales

*   **Motor del Juego Roblox (Roblox Integration):** Provee endpoints REST seguros para la comunicación bidireccional con los servidores de Roblox. Sincroniza datos esenciales de los jugadores como *Dracoins*, slots de dragones y límites de almacenamiento.
*   **Vinculación Criptográfica de Cuentas:** Sistema seguro de códigos temporales de vinculación basados en firma **HMAC (LinkCodePepper)** para asociar de forma segura la cuenta web del usuario con su personaje dentro del juego de Roblox.
*   **Arquitectura Desacoplada:**
    *   `Biblioteca/`: Módulo de clases de C# que encapsula las reglas del negocio, entidades y acceso a datos.
    *   `ImperiusDraconisAPI/`: API REST en **ASP.NET Core** que expone los servicios consumidos por el frontend web y el juego.
*   **Seguridad:** Autenticación de usuarios basada en JWT (JSON Web Tokens) y APIs protegidas para servidores autorizados del juego.
*   **Almacenamiento Persistente:** Gestión de volúmenes para archivos subidos por el usuario (fotos de perfil, contenido dinámico) persistidos directamente en Docker.

---

## 🛠️ Stack Tecnológico

*   **Backend & API:** C# / .NET 8 / ASP.NET Core
*   **Base de Datos:** SQL Server (alojado en SmartASP)
*   **Contenerización & CI/CD:** Dockerfile / Docker Compose
*   **Despliegue e Infraestructura:** VPS Oracle Cloud (Ubuntu) administrado eficientemente mediante **Coolify**.

---

## ⚙️ Variables de Entorno Clave (API)

Para su ejecución en producción (Coolify/Docker), se configuran las siguientes variables de entorno:

```text
ASPNETCORE_ENVIRONMENT=Production
ConnectionStrings__DefaultConnection=CADENA_CONEXION_SQLSERVER_SMARTASP
Jwt__SecretKey=SECRETO_FIRMADO_JWT_MIN_32_CHARS
Game__ApiKey=TOKEN_SEGURIDAD_SERVIDOR_ROBLOX
Game__LinkCodePepper=SECRETO_HMAC_VINCULACION
Game__LinkCodeExpirationMinutes=10
Game__WelcomeDracoins=400
Game__BaseDragonSlots=1
Game__MaxDragonCapacity=10
```

---

## 📦 Ejecución Local

### Prerrequisitos
*   .NET 8.0 SDK o superior instalado.
*   Acceso a una base de datos SQL Server activa.

### Pasos
1.  Clona el repositorio:
    ```bash
    git clone https://github.com/MZubiri/ImperiusDraconis-Core.git
    cd ImperiusDraconis-Core
    ```
2.  Configura la cadena de conexión en `appsettings.json` o mediante secretos de desarrollo.
3.  Compila y ejecuta la API:
    ```bash
    dotnet run --project ImperiusDraconisAPI/ImperiusDraconisAPI
    ```

La API estará lista para escuchar peticiones locales (generalmente en `http://localhost:5000` o `http://localhost:5024`).
