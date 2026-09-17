# Puesta en marcha en Roblox Studio

## 1. Instalar y conectar Rojo

1. Instala el complemento **Rojo** desde Creator Store y el ejecutable Rojo en tu PC.
2. Abre una terminal en la carpeta `ROBLOX` y ejecuta `rojo serve`.
3. Crea o abre la experiencia en Roblox Studio.
4. Abre el complemento Rojo, conecta con `localhost:34872` y sincroniza el proyecto.

La sincronización debe crear:

- `ServerScriptService/ImperiusDragons/ApiClient`
- `ServerScriptService/ImperiusDragons/GameServer`
- `StarterPlayer/StarterPlayerScripts/ImperiusDragons/GameClient`

## 2. Configurar comunicación con la API

1. En Studio abre **Game Settings → Security**.
2. Activa **Allow HTTP Requests**.
3. Selecciona `ServerStorage` en Explorer y crea estos atributos de tipo `String`:
   - `IMPERIUS_API_URL` = `https://api.imperiusdraconis.online/api/game/v1`
   - `IMPERIUS_GAME_API_KEY` = la misma clave configurada como `Game__ApiKey` en la API de producción.
4. No copies la clave a `ReplicatedStorage`, `StarterPlayer` ni a un `LocalScript`.

## 3. Probar el flujo completo

1. Publica una versión privada de la experiencia y entra con una cuenta de prueba.
2. En `https://imperiusdraconis.online/imperius-dragons`, inicia sesión y genera un código.
3. Introduce el código en Roblox.
4. Verifica, en este orden: saldo inicial, compra de huevo, incubación, eclosión, selección, alimentación, caricia, misiones, duelo, ranking y regalo a una segunda cuenta.
5. En el portal administrativo abre `/game-admin` y confirma que aparecen el jugador, ledger, huevos y dragones.

## 4. Publicar

Cuando la prueba privada termine, usa **File → Publish to Roblox**. Mantén la experiencia privada hasta completar el flujo anterior.

## Diagnóstico rápido

- `Falta ServerStorage.IMPERIUS_API_URL`: falta el atributo o está vacío.
- `Falta ServerStorage.IMPERIUS_GAME_API_KEY`: falta la clave o tiene menos de 32 caracteres.
- `NETWORK_ERROR`: HTTP está desactivado, la URL no responde o Roblox bloqueó la petición.
- `NOT_LINKED`: genera un código nuevo en el portal y vuelve a vincular.
