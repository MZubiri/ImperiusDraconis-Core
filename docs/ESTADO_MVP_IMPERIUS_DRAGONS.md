# Estado del MVP de Imperius Dragons

Fecha de validación: 17 de septiembre de 2026.

## Producción

Desplegado en `https://imperiusdraconis.online` y `https://api.imperiusdraconis.online` desde el commit `9414070`. Antes del cambio se generó y restauró localmente un respaldo completo. Las migraciones 019 y 020 se aplicaron en producción y ambas aplicaciones finalizaron correctamente en Coolify.

## Alcance implementado

- Vinculación segura entre una cuenta de Imperius y Roblox.
- Compra, incubación, eclosión, nombre y regalo de huevos.
- Inventario, selección y capacidad de dragones.
- Hambre, felicidad, vida, caricias, alimentos, huida, experiencia y etapas.
- Tres misiones diarias con progreso transaccional y reclamo idempotente.
- Combate automático, elementos, etapas, temperamentos, bonos de casa y ranking.
- Panel web para soporte, ledger, restauración y balance de huevos, alimentos y misiones.
- Cliente y servidor Luau sincronizables con Rojo.

## Validación automatizada

- `dotnet build`: sin advertencias ni errores.
- Pruebas .NET: 59 aprobadas; las pruebas que requieren bases aisladas se ejecutan por separado.
- Flujo Game sobre MySQL: aprobado.
- Migraciones 001–020: aprobadas y repetibles.
- `npx ng build`: aprobado; permanece una advertencia histórica de presupuesto CSS de Biblioteca.
- Pruebas Angular: 9 aprobadas.
- Los tres archivos Luau pasan análisis sintáctico con `luau-parser` 1.0.3.

## Límites que requieren Roblox Studio

El repositorio no puede publicar una experiencia ni asignar secretos de Roblox. La prueba final debe hacerse en Studio con HTTP habilitado, los dos atributos privados configurados y una cuenta de prueba vinculada. Los modelos actuales son figuras provisionales generadas por código; los modelos, mapa, sonidos y animaciones definitivos son trabajo de contenido visual.

Las migraciones 019 y 020 fueron desplegadas junto con la versión de API que las consume.
