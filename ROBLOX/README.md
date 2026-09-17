# Imperius Dragons — Roblox

Proyecto Rojo del juego. El backend de Imperius es la fuente oficial de saldo,
huevos, dragones y progreso; no se duplican esos datos en DataStoreService.

La guía completa de instalación, prueba y publicación está en [PUESTA_EN_MARCHA.md](PUESTA_EN_MARCHA.md).

## Configuración en Studio

1. Instalar Rojo y sincronizar `default.project.json` con una experiencia Roblox.
2. Activar **Allow HTTP Requests** en Game Settings → Security.
3. En `ServerStorage`, establecer los atributos del servicio:
   - `IMPERIUS_API_URL`: `https://api.imperiusdraconis.online/api/game/v1`
   - `IMPERIUS_GAME_API_KEY`: la clave Game de producción.
4. Nunca colocar la API key en ReplicatedStorage, StarterPlayer o un LocalScript.

`GameServer.server.luau` crea `ReplicatedStorage.ImperiusGameRequest`. El cliente
solicita acciones, pero el servidor siempre sustituye cualquier identidad recibida
por `Player.UserId` antes de llamar al API.
