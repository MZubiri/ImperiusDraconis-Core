# Despliegue En Oracle VPS Con Coolify

> **Estado verificado el 9 de junio de 2026:** el entorno beta usa
> `https://beta.imperiusdraconis.lat` para Angular y
> `https://api-beta.imperiusdraconis.lat` para ASP.NET Core. Los dominios sin
> `beta` descritos abajo representan el objetivo de produccion y no deben usarse para
> probar el entorno beta.

## Arquitectura

- Frontend Angular: `https://imperiusdraconis.lat`
- API ASP.NET Core: `https://api.imperiusdraconis.lat`
- Base de datos: SQL Server existente en SmartASP
- No se incluye ni ejecuta ninguna migracion a PostgreSQL.

## Requisitos Previos

1. Subir el repositorio a un proveedor Git accesible por Coolify.
2. Crear los registros DNS:

   | Tipo | Nombre | Valor |
   | --- | --- | --- |
   | A | `@` | `147.15.100.230` |
   | A | `api` | `147.15.100.230` |
   | A opcional | `www` | `147.15.100.230` |

3. Permitir conexiones salientes desde Oracle VPS hacia el SQL Server de SmartASP.
4. Ejecutar previamente las migraciones SQL Server controladas que necesite la aplicacion.

## Variables De Entorno De La API

Configurar como variables de entorno de runtime en Coolify:

```text
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:8080
ConnectionStrings__DefaultConnection=CADENA_SQLSERVER_SMARTASP
Jwt__SecretKey=SECRETO_ALEATORIO_DE_AL_MENOS_32_CARACTERES
Game__ApiKey=SECRETO_PARA_SERVIDOR_ROBLOX
Game__Version=1.0.0
Game__LinkCodePepper=SECRETO_HMAC_DIFERENTE
Game__LinkCodeExpirationMinutes=10
Game__WelcomeDracoins=400
Game__BaseDragonSlots=1
Game__MaxDragonCapacity=10
```

La cadena SQL Server debe incluir los parametros requeridos por SmartASP. Ejemplo de
forma, sin credenciales reales:

```text
Server=SERVIDOR;Database=BASE;User Id=USUARIO;Password=CLAVE;MultipleActiveResultSets=True;TrustServerCertificate=True;
```

No guardar estas variables como argumentos de build. Deben configurarse como secretos
o variables de runtime del servicio.

Variables SMTP opcionales:

```text
Smtp__Host=
Smtp__Port=587
Smtp__Username=
Smtp__Password=
Smtp__FromEmail=
Smtp__FromName=Imperius Draconis
Smtp__EnableSsl=true
```

## Servicio API En Coolify

1. Crear un recurso `Application` desde el repositorio.
2. Seleccionar despliegue mediante `Dockerfile`.
3. Configurar:

   | Opcion | Valor |
   | --- | --- |
   | Base Directory | `/ImperiusDraconisAPI/ImperiusDraconisAPI` |
   | Dockerfile Location | `/Dockerfile` |
   | Puerto interno | `8080` |
   | Dominio | `https://api.imperiusdraconis.lat` |

4. Agregar las variables de entorno indicadas arriba.
5. Configurar almacenamiento persistente:

   | Source | Destination |
   | --- | --- |
   | Volumen administrado por Coolify | `/app/wwwroot/Content` |

   Este volumen conserva fotos de perfil, imagenes de productos, Rincon y chismes
   subidas por los usuarios. Antes del primer despliegue productivo, copiar al volumen
   los archivos existentes de `wwwroot/Content` si deben conservarse.

6. Desplegar y revisar los logs. La API debe mostrar que escucha en `http://+:8080`.

El contenedor no ejecuta migraciones de base de datos al iniciar.

## Servicio Frontend En Coolify

1. Crear otro recurso `Application` desde el mismo repositorio.
2. Seleccionar despliegue mediante `Dockerfile`.
3. Configurar:

   | Opcion | Valor |
   | --- | --- |
   | Base Directory | `/IMPERIUSDRACONIS` |
   | Dockerfile Location | `/Dockerfile` |
   | Puerto interno | `80` |
   | Dominio | `https://imperiusdraconis.lat` |

4. Configurar la variable de entorno de runtime:

   ```text
   API_URL=https://api.imperiusdraconis.lat/api
   ```

5. Desplegar después de que `api.imperiusdraconis.lat` esté disponible.

El contenedor genera al iniciar:

```text
/usr/share/nginx/html/assets/config/runtime-config.json
```

La misma imagen puede apuntar a otra API modificando solamente `API_URL` y reiniciando
el contenedor. No requiere recompilar Angular. La implementacion se documenta en:

```text
IMPERIUSDRACONIS/README_RUNTIME_CONFIG.md
```

## Proxy Y TLS

Coolify puede administrar dominios, proxy inverso y certificados TLS directamente.
Evitar configurar simultaneamente el mismo dominio en Coolify y Nginx Proxy Manager,
porque ambos competirian por los puertos y certificados. Si Nginx Proxy Manager sera
el proxy publico, no asignar esos dominios al proxy de Coolify y enrutar NPM hacia los
puertos publicados correspondientes.

## Validacion Posterior

1. Abrir `https://api.imperiusdraconis.lat/api/auth/me`.
   Una respuesta `401 Unauthorized` confirma que la API responde y protege el endpoint.
2. Abrir `https://imperiusdraconis.lat`.
3. Iniciar sesion con una cuenta valida.
4. Verificar que las imagenes servidas desde la API carguen correctamente.
5. Confirmar que los archivos subidos persisten tras reconstruir la API.

Para beta, sustituir el dominio API por `https://api-beta.imperiusdraconis.lat`.
`https://beta.imperiusdraconis.lat/api/...` no llega al backend porque el Nginx del
frontend no configura `proxy_pass`.

## Desarrollo Local

Las credenciales ya no viven en `appsettings*.json`. Para ejecutar localmente, definir:

```bash
export ConnectionStrings__DefaultConnection='CADENA_SQLSERVER_LOCAL'
export Jwt__SecretKey='SECRETO_LOCAL_DE_AL_MENOS_32_CARACTERES'
dotnet run
```

El frontend de desarrollo usa el archivo runtime local con:

```text
http://localhost:8080/api
```
