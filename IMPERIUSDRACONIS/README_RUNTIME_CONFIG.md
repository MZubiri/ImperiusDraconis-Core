# Configuracion Runtime De La API

El frontend Angular obtiene la URL del backend desde:

```text
/assets/config/runtime-config.json
```

`RuntimeConfigService` carga ese archivo antes de iniciar la aplicacion. Los servicios
HTTP y los helpers de recursos usan `RuntimeConfigService.apiUrl`, por lo que la URL
no queda incluida en los bundles JavaScript de produccion.

## Desarrollo Local

Al ejecutar:

```bash
npm start
```

Angular sirve `src/assets/config/runtime-config.json`, configurado con:

```text
http://localhost:8080/api
```

## Docker

La imagen incluye:

```text
src/assets/config/runtime-config.template.json
docker-entrypoint.d/40-runtime-config.sh
```

Cuando inicia el contenedor, el script usa `envsubst` para reemplazar `${API_URL}` y
genera:

```text
/usr/share/nginx/html/assets/config/runtime-config.json
```

El Dockerfile copia explícitamente el template a la raíz servida por nginx y el script
crea `/usr/share/nginx/html/assets/config` si todavía no existe.

La variable `API_URL` es obligatoria. Ejemplo:

```bash
docker run --rm -p 8080:80 \
  -e API_URL=https://api.imperiusdraconis.lat/api \
  imperius-frontend
```

La misma imagen puede iniciarse con otro backend sin reconstruirla:

```bash
API_URL=https://api-beta.imperiusdraconis.lat/api
API_URL=https://coolify-random-domain/api
```

## Coolify

En el servicio del frontend, agregar como variable de entorno de runtime:

```text
API_URL=https://api.imperiusdraconis.lat/api
```

Para cambiar de entorno:

1. Modificar `API_URL` en Coolify.
2. Reiniciar o redesplegar el contenedor usando la misma imagen.

No es necesario recompilar Angular. El archivo runtime se genera en cada arranque y
nginx lo entrega con encabezados que evitan cachearlo.

## Verificacion En Coolify

Despues de publicar cambios del Dockerfile o del script de inicio:

1. Ejecutar un nuevo despliegue del frontend en Coolify reconstruyendo la imagen.
2. Confirmar en los logs del contenedor:

   ```text
   Configuracion runtime generada en /usr/share/nginx/html/assets/config/runtime-config.json
   ```

3. Verificar dentro del contenedor:

   ```bash
   cat /usr/share/nginx/html/assets/config/runtime-config.json
   ```

4. Abrir:

   ```text
   https://DOMINIO_FRONTEND/assets/config/runtime-config.json
   ```

Si el dominio responde `404` pero la imagen local responde correctamente, el servicio
publicado todavía está usando una imagen anterior o una configuración de build distinta.
