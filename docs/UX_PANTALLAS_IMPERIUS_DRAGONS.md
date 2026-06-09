# Imperius Dragons

## Documento de UX y Pantallas del MVP

**Versión:** 1.0

**Fecha:** 9 de junio de 2026

**Objetivo:** permitir que un desarrollador Roblox y un diseñador de interfaces
construyan la experiencia completa del jugador leyendo únicamente este documento.

**Plataformas objetivo:** móvil, PC y tablet dentro de Roblox.

---

# 1. Principios de UX

## 1.1 Qué debe sentir el jugador

La experiencia debe producir cuatro sensaciones principales:

| Sensación | Cómo se logra |
|---|---|
| Vínculo | El dragón ocupa el centro visual, reacciona y expresa necesidades claramente |
| Curiosidad | Los huevos, regalos y rarezas prometen descubrimientos |
| Progreso | Cada sesión permite reclamar, cuidar, combatir o ahorrar |
| Pertenencia | La casa Imperius aparece como identidad, no como decoración aislada |

El jugador nunca debe sentir que está administrando una hoja de estadísticas. Debe
sentir que visita a una criatura mágica que lo reconoce y que siempre existe una acción
breve y significativa.

## 1.2 Tiempo objetivo de interacción

| Interacción | Tiempo objetivo |
|---|---:|
| Entender la pantalla principal | Menos de 5 segundos |
| Revisar necesidades del dragón | Menos de 3 segundos |
| Alimentar | 2-5 segundos |
| Acariciar | 2-4 segundos |
| Reclamar misión | 2 segundos |
| Comprar huevo o alimento | Menos de 15 segundos |
| Seleccionar dragón para duelo | Menos de 15 segundos |
| Duelo completo | 30-75 segundos |
| Sesión normal completa | 5-15 minutos |

## 1.3 Prioridades visuales

El orden visual siempre debe ser:

1. Dragón o huevo protagonista.
2. Acción recomendada inmediata.
3. Estado crítico o recompensa disponible.
4. Dracoins y progreso.
5. Navegación secundaria.

Reglas:

- Mostrar una sola llamada principal a la acción por pantalla.
- Usar texto breve y lenguaje afectivo.
- No mostrar más de tres barras de progreso juntas fuera de la ficha del dragón.
- Reservar animaciones intensas para nacimientos, evoluciones y rarezas altas.
- Mantener información avanzada oculta hasta que el jugador la solicite.

## 1.4 Principios de navegación

- La pantalla principal es siempre el punto de regreso.
- La navegación principal tiene cinco destinos:
  `Inicio`, `Dragones`, `Huevos`, `Misiones` y `Duelo`.
- `Tienda` y `Ranking` son accesos destacados secundarios.
- En móvil, usar barra inferior.
- En PC y tablet ancha, usar barra lateral izquierda.
- Cerrar una pantalla secundaria devuelve al contexto anterior, no siempre a Inicio.
- Los botones críticos nunca dependen únicamente de tocar el modelo 3D.

## 1.5 Estados universales

Toda pantalla debe contemplar:

| Estado | Tratamiento UX |
|---|---|
| Cargando | Siluetas suaves y texto “Consultando los registros mágicos…” |
| Sin contenido | Ilustración, explicación breve y siguiente acción |
| Acción exitosa | Animación corta, resultado visible y sonido suave |
| Acción no disponible | Botón desactivado con motivo visible |
| Error temporal | Mantener contexto y ofrecer `Reintentar` |
| Confirmación sensible | Modal claro antes de gastar Dracoins o regalar un huevo |

## 1.6 Errores comunes a evitar

- Ocultar Hambre, Felicidad o Vida detrás de varios menús.
- Usar rojo para cualquier cosa que no sea realmente urgente.
- Abrir ventanas emergentes consecutivas al entrar.
- Mostrar demasiadas monedas, porcentajes o estadísticas a jugadores nuevos.
- Hacer que el jugador espere mirando un temporizador de incubación.
- Permitir compras accidentales con un solo toque.
- Presentar el regalo de huevo sin nombre claro del destinatario.
- Comunicar la huida como muerte o castigo irreversible.
- Usar solo color para expresar rareza, elemento o estado.
- Colocar botones pequeños cerca de los controles de movimiento móvil.

---

# 2. Flujo de nuevo jugador

## 2.1 Objetivo del onboarding

El jugador debe comprender en su primera sesión:

- Qué es Imperius Dragons.
- Por qué debe vincular su cuenta.
- Cómo obtener un huevo.
- Que el huevo necesita tiempo para incubar.
- Que regresará para conocer a su primer dragón.

La primera incubación mantiene sus 30 minutos normales. El onboarding se divide en:

- **Sesión 1:** vinculación, recompensa, compra e inicio de incubación.
- **Sesión 2 o regreso posterior:** nacimiento, ficha del dragón y acompañante.

## 2.2 Paso 1: primera entrada al juego

### Qué ve

- Patio mágico al atardecer.
- Un pedestal de incubación vacío en el centro.
- Logo `Imperius Dragons`.
- Texto: “Tu vínculo con los dragones está a punto de comenzar.”
- Botón principal: `Comenzar`.
- Botón discreto: `Saltar introducción`.

### Comportamiento

- Cinemática máxima de 12 segundos.
- Cámara muestra brevemente patio, zona de huevos y arena.
- El movimiento se habilita después de pulsar `Comenzar`.
- No mostrar tienda, ranking ni barras complejas todavía.

## 2.3 Paso 2: tutorial inicial

Un personaje guía llamado **Custodio Dracónico** recibe al jugador.

### Diálogo

1. “En Imperius, cada cuidador puede formar un vínculo con un dragón.”
2. “Primero debemos reconocerte como miembro de la comunidad.”
3. “Después elegiremos un huevo y prepararemos su incubación.”

### Presentación

- Caja de diálogo inferior.
- Retrato del Custodio.
- Máximo dos líneas visibles por mensaje.
- Botones `Continuar` y `Omitir tutorial`.

Si se omite, el jugador pasa directamente a Vinculación, pero conserva ayudas
contextuales en cada pantalla.

## 2.4 Paso 3: vinculación con Imperius

### Qué ve

Pantalla de pergamino centrada:

- Título: `Vincula tu cuenta Imperius`.
- Explicación: “Obtén tu código desde tu perfil Imperius e introdúcelo aquí.”
- Campo de código grande, dividido visualmente en seis espacios.
- Botón principal: `Vincular`.
- Enlace secundario: `¿Dónde encuentro mi código?`.
- Mensaje de confianza: “Nunca te pediremos tu contraseña dentro de Roblox.”

### Estados

| Estado | Mensaje |
|---|---|
| Código vacío | “Escribe el código de vinculación.” |
| Código inválido | “Ese código no es válido. Revisa los caracteres.” |
| Código vencido | “El código perdió su magia. Genera uno nuevo en Imperius.” |
| Cuenta ya vinculada | “Esta cuenta ya está vinculada. Solicita ayuda si no la reconoces.” |
| Éxito | Sello de la casa, nombre del jugador y texto “Vínculo confirmado.” |

### Ayuda visual

`¿Dónde encuentro mi código?` abre tres ilustraciones:

1. Entra a tu perfil Imperius.
2. Busca `Vincular Roblox`.
3. Genera y escribe el código.

## 2.5 Paso 4: recompensa inicial

Tras vincular:

- Aparece el escudo de la casa del jugador.
- Cofre pequeño se abre.
- Texto principal: `Bienvenido a Imperius Dragons`.
- Recompensa visible: `+400 Dracoins`.
- Se muestra el bono de casa en una tarjeta breve.

Ejemplo:

> “Como integrante de Ravenclaw, obtienes +5 % de experiencia al reclamar misiones.”

Botón: `Elegir mi primer huevo`.

## 2.6 Paso 5: compra del primer huevo

El jugador entra en una versión simplificada de la tienda:

- Solo se destaca el `Huevo del Hogar`.
- Precio: `300 DC`.
- Saldo visible: `400 DC`.
- Probabilidades resumidas.
- Mensaje: “Tu primer huevo ocupa tu espacio gratuito.”
- Botón principal: `Comprar por 300 DC`.

Al pulsar:

1. Mostrar confirmación con saldo antes y después.
2. Ejecutar compra.
3. Reproducir aparición del huevo sobre el pedestal.
4. Mostrar `100 DC restantes`.

## 2.7 Paso 6: incubación

### Qué ve

- Huevo del Hogar sobre pedestal.
- Temporizador grande: `29:59`.
- Estado: `Incubando`.
- Texto: “El huevo estará listo en 30 minutos. Puedes volver más tarde.”
- Botón principal: `Ver qué puedo hacer`.
- Botón secundario: `Salir por ahora`.

### Experiencia durante la espera

- El jugador puede explorar el patio y revisar la guía.
- No se le exige permanecer conectado.
- Al salir, mensaje: “Te avisaremos dentro del juego cuando el huevo esté listo.”
- Al volver con el huevo listo, la interfaz conduce inmediatamente al nacimiento.

## 2.8 Paso 7: nacimiento del primer dragón

### Entrada de regreso

La pantalla muestra:

- Fondo oscurecido.
- Mensaje: `Tu huevo está listo`.
- Botón brillante: `Presenciar nacimiento`.

### Secuencia

1. Cámara se acerca al pedestal.
2. El huevo vibra y muestra partículas de rareza.
3. Se rompe la cáscara.
4. Aparece el dragón bebé.
5. Se revela en este orden:
   `Especie → Rareza → Elemento → Temperamento`.
6. Aparece campo para nombre.

### Duración

- Común o Raro: 8-12 segundos.
- Épico o Legendario: 12-18 segundos.
- Mítico: ceremonia de hasta 25 segundos, con opción de omitir tras 5 segundos.

### Mensaje

> “Ha nacido un Brasaloma Raro de temperamento Juguetón.”

Botón: `Conocer a mi dragón`.

## 2.9 Paso 8: selección como acompañante

Se abre la ficha simplificada:

- Modelo 3D del bebé.
- Nombre, rareza, elemento y temperamento.
- Hambre 80, Felicidad 80, Vida 100.
- Botón principal: `Elegir como acompañante`.

Tras seleccionar:

- El dragón aparece junto al jugador.
- Reacciona según temperamento.
- Tutorial señala las barras de necesidades.
- Mensaje final: “Tu vínculo ha comenzado. Cuídalo, completa misiones y descubre hasta
  dónde puede crecer.”
- Se desbloquea la navegación completa.

---

# 3. Pantalla principal

## 3.1 Objetivo

La pantalla principal debe responder inmediatamente:

1. ¿Cómo está mi dragón?
2. ¿Qué puedo hacer ahora?
3. ¿Tengo algo listo o reclamable?
4. ¿Cuántos Dracoins tengo?

## 3.2 Distribución

### Zona superior

- Avatar/nombre y escudo de casa a la izquierda.
- Dracoins a la derecha.
- Botón `+` junto a Dracoins abre Tienda.
- Icono de notificaciones con contador.

### Zona central

- Dragón acompañante visible en el mundo.
- Tarjeta compacta flotante con nombre, nivel y tres necesidades.
- Botón contextual principal según prioridad.

Prioridad de acción contextual:

1. `Atender ahora` si Vida está en riesgo.
2. `Alimentar` si Hambre está baja.
3. `Reclamar misión` si existe recompensa.
4. `Abrir huevo` si está listo.
5. `Acariciar` si está disponible.
6. `Iniciar duelo`.

### Zona inferior/lateral

Navegación principal:

- Inicio.
- Dragones.
- Huevos.
- Misiones.
- Duelo.

Accesos secundarios:

- Tienda.
- Ranking.
- Regalos pendientes.

## 3.3 Información visible

- Nombre del dragón seleccionado.
- Etapa y nivel.
- Hambre, Felicidad y Vida con icono y color.
- Cooldown de caricia, solo si está cerca de estar disponible.
- Huevo listo o temporizador más próximo.
- Misiones reclamables.
- Espacios usados: por ejemplo `2/3`.
- Dracoins actuales.

## 3.4 Wireframe textual: PC/tablet

```text
┌──────────────────────────────────────────────────────────────────────┐
│ [Escudo] Nombre                         [Regalos 1] [🔔 2] [DC 425 +]│
├───────────────┬──────────────────────────────────────┬───────────────┤
│ [Inicio]      │                                      │ BRASALOMA     │
│ [Dragones]    │          MUNDO / DRAGÓN              │ Bebé · Nivel 3│
│ [Huevos]      │          ACOMPAÑANTE                  │ Hambre   42   │
│ [Misiones 1]  │                                      │ Felicidad 76  │
│ [Duelo]       │        [Acción: Acariciar]           │ Vida     100  │
│               │                                      │ [Ver dragón]  │
│ [Tienda]      │                                      │               │
│ [Ranking]     │                                      │ Huevo: 01:42h │
├───────────────┴──────────────────────────────────────┴───────────────┤
│ Consejo: “Brasaloma parece contento de verte.”         Espacios 1/2 │
└──────────────────────────────────────────────────────────────────────┘
```

## 3.5 Wireframe textual: móvil

```text
┌────────────────────────────┐
│ [Escudo] Nombre   [DC 425] │
│                 [🔔 2] [+] │
├────────────────────────────┤
│                            │
│      MUNDO / DRAGÓN        │
│                            │
│ [Brasaloma · Nv.3]         │
│ H 42   F 76   V 100        │
│ [      Acariciar      ]    │
├────────────────────────────┤
│ Huevo 01:42h · Misión 1 ✓  │
├────────────────────────────┤
│ Inicio Dragón Huevo Misión │
│            Duelo           │
└────────────────────────────┘
```

---

# 4. Pantalla del dragón

## 4.1 Objetivo

Concentrar vínculo, cuidado y progreso sin convertir la pantalla en un panel técnico.

## 4.2 Distribución

### Cabecera

- Botón volver.
- Nombre del dragón.
- Selector entre dragones.
- Estado `Acompañante` si está seleccionado.

### Modelo 3D

- Ocupa entre 40 % y 55 % de la pantalla.
- Puede rotarse arrastrando.
- Botón discreto para ocultar interfaz y observarlo.
- Reacciona al tocarlo, pero el botón `Acariciar` sigue siendo explícito.

### Identidad

- Especie.
- Rareza con color, marco, icono y texto.
- Elemento con icono y nombre.
- Temperamento con descripción breve.
- Etapa y nivel.

### Necesidades

Tres barras claramente separadas:

- Hambre: icono de alimento.
- Felicidad: icono de corazón.
- Vida: icono de brillo vital.

Estados:

| Valor | Tratamiento |
|---:|---|
| 60-100 | Normal |
| 30-59 | Atención suave |
| 1-29 | Advertencia |
| 0 | Estado crítico o huida |

### Progreso

- Nivel actual.
- Barra de experiencia.
- Requisitos de crecimiento.
- Mostrar el requisito faltante más importante primero.

### Acciones

- `Alimentar`.
- `Acariciar` o temporizador.
- `Elegir como acompañante`.
- `Renombrar`.

## 4.3 Wireframe textual

```text
┌─────────────────────────────────────────────────────────────────┐
│ [←] BRASALOMA                         [Acompañante ✓] [Cambiar] │
├───────────────────────────────┬─────────────────────────────────┤
│                               │ Raro · Fuego                    │
│       MODELO 3D               │ Temperamento: Juguetón          │
│       ROTABLE                 │ “Disfruta llamar tu atención.”  │
│                               │                                 │
│       [Ocultar UI]            │ Bebé · Nivel 3                  │
│                               │ XP 42 / 80  [█████░░░░░]        │
├───────────────────────────────┼─────────────────────────────────┤
│ Hambre     42 [████░░░░░░]    │ Para crecer:                    │
│ Felicidad  76 [████████░░]    │ ✓ Tiempo 24h                    │
│ Vida      100 [██████████]    │ ○ Experiencia 42/80             │
├───────────────────────────────┴─────────────────────────────────┤
│ [ Alimentar ] [ Acariciar · disponible ] [ Renombrar ]         │
└─────────────────────────────────────────────────────────────────┘
```

## 4.4 Selector de alimento

Al pulsar `Alimentar`, abrir panel inferior o lateral:

- Estado actual del dragón fijo arriba.
- Tarjetas de alimentos.
- Costo.
- Beneficios con iconos.
- Vista previa del valor resultante.

Ejemplo:

```text
┌────────────────────────────────────────┐
│ Alimentar a Brasaloma        Hambre 42 │
├────────────────────────────────────────┤
│ Bocado de Granero     8 DC             │
│ Hambre +20            Resultado: 62    │
│ [Elegir]                               │
├────────────────────────────────────────┤
│ Fruta Solar           15 DC            │
│ Hambre +20 · Felicidad +5              │
│ [Elegir]                               │
└────────────────────────────────────────┘
```

## 4.5 Caricia

### Disponible

- Botón muestra icono de mano y texto `Acariciar`.
- Al pulsar, ocultar botones durante 2 segundos.
- Reproducir reacción según temperamento.
- Mostrar `Felicidad +6`.
- Si obtiene XP: `¡El vínculo se fortalece! XP +3`.

### En cooldown

- Botón desactivado: `Descansando · 02:18h`.
- Al tocarlo, mostrar explicación breve.

## 4.6 Dragón huido

No mostrar tumba, oscuridad extrema ni lenguaje de muerte.

Pantalla:

- Silueta tenue del dragón.
- Texto: “{Nombre} se alejó porque necesitaba cuidados.”
- Mensaje: “Tu vínculo no se ha perdido. Un custodio puede ayudarte.”
- Botón: `Solicitar ayuda`.
- Acciones de alimentar, acariciar, acompañar y combatir desactivadas.

---

# 5. Pantalla de huevos

## 5.1 Objetivo

Mostrar claramente qué huevos posee el jugador, cuáles están listos y qué acciones
puede realizar.

## 5.2 Distribución

- Cabecera con `Huevos`, espacios usados y botón `Tienda`.
- Pestañas:
  - `Mis huevos`.
  - `Regalos`.
- Tarjetas grandes, ordenadas:
  1. Listos para abrir.
  2. Incubando.
  3. Pendientes.

## 5.3 Tarjeta de huevo

Debe mostrar:

- Modelo o ilustración del huevo.
- Tipo.
- Rareza visible.
- Estado.
- Tiempo restante.
- Elemento o casa si aplica.
- Botón principal contextual.
- Botón secundario `Regalar`, salvo si existe solicitud pendiente.

Estados:

| Estado | Acción principal |
|---|---|
| Pendiente | `Iniciar incubación` |
| Incubando | Temporizador, sin acción |
| Listo | `Presenciar nacimiento` |
| Regalo pendiente enviado | `Esperando respuesta` |
| Regalo recibido | `Aceptar` y `Rechazar` |

## 5.4 Regalar huevo

Flujo:

1. Pulsar `Regalar`.
2. Introducir código Imperius del destinatario.
3. Mostrar identidad confirmada: nombre, casa y avatar.
4. Confirmar:
   “¿Quieres regalar este Huevo Elemental Raro a Luna?”
5. Mostrar que conserva rareza y progreso.
6. Tras enviar: estado `Esperando respuesta`.

## 5.5 Wireframe textual

```text
┌──────────────────────────────────────────────────────────────┐
│ [←] HUEVOS                      Espacios 2/3  [Ir a Tienda]  │
│ [Mis huevos] [Regalos 1]                                    │
├──────────────────────┬──────────────────────┬────────────────┤
│ HUEVO DEL HOGAR      │ HUEVO ELEMENTAL     │ HUEVO ARCANO   │
│ [modelo]             │ [modelo]            │ [modelo]       │
│ Común                │ Raro · Hielo        │ Épico          │
│ LISTO                │ Incubando 01:42h    │ Sin incubar    │
│ [Abrir] [Regalar]    │ [Ver] [Regalar]     │ [Incubar]      │
├──────────────────────┴──────────────────────┴────────────────┤
│ Regalo recibido: Huevo del Emblema Épico de Alex            │
│ [Ver regalo]                                                  │
└──────────────────────────────────────────────────────────────┘
```

## 5.6 Estado vacío

Texto:

> “Aún no tienes huevos. Encuentra uno en la tienda o recibe un regalo.”

Botones:

- `Ver tienda`.
- `Revisar regalos`.

---

# 6. Pantalla de misiones

## 6.1 Objetivo

Convertir actividades breves en una lista clara de próximos objetivos y recompensas.

## 6.2 Distribución

Pestañas:

- `Diarias` con tiempo restante.
- `Semanales` con tiempo restante.
- `Especiales`.

Cada misión muestra:

- Icono temático.
- Nombre.
- Descripción de una línea.
- Progreso numérico y barra.
- Dracoins y XP.
- Estado y botón.

## 6.3 Estados de misión

| Estado | Apariencia | Botón |
|---|---|---|
| En progreso | Barra neutral | `Ver objetivo` |
| Completada | Resplandor suave | `Reclamar` |
| Reclamada | Marca de verificación | `Reclamada` |
| Vencida | Atenuada | Sin botón |

## 6.4 Wireframe textual

```text
┌──────────────────────────────────────────────────────────────┐
│ [←] MISIONES                         Reinicio diario 08:42h  │
│ [Diarias 3] [Semanales 2] [Especiales]                      │
├──────────────────────────────────────────────────────────────┤
│ 🍖 BUEN CUIDADOR                                             │
│ Alimenta a un dragón 1 vez                                  │
│ 1/1 [████████████]        Recompensa: 15 DC · 8 XP          │
│                                          [ RECLAMAR ]        │
├──────────────────────────────────────────────────────────────┤
│ ⚔ APRENDIZ DE DUELISTA                                      │
│ Completa 3 duelos                                            │
│ 1/3 [████░░░░░░░░]        Recompensa: 35 DC · 15 XP         │
│                                        [ Ver objetivo ]      │
├──────────────────────────────────────────────────────────────┤
│ ☀ ÁNIMO RADIANTE                                             │
│ Lleva Felicidad a 70                                         │
│ 76/70 [████████████]       Recompensa: 15 DC · 8 XP         │
│                                          [ RECLAMAR ]        │
└──────────────────────────────────────────────────────────────┘
```

## 6.5 Reclamo

- Al pulsar `Reclamar`, la tarjeta se transforma sin cerrar la pantalla.
- Dracoins vuelan visualmente hacia el contador superior.
- XP se muestra junto al dragón seleccionado.
- Si aplica bono de casa, mostrar una línea separada:
  `Bono Ravenclaw: +1 XP acumulado`.

---

# 7. Pantalla de combate

## 7.1 Objetivo

Ofrecer un duelo automático comprensible, breve y emocionante, sin prometer control en
tiempo real.

## 7.2 Flujo

1. Selección del dragón.
2. Vista previa del rival.
3. Confirmación.
4. Presentación de rondas.
5. Resultado y recompensas.

## 7.3 Selección de dragón

Mostrar:

- Dragones disponibles.
- Nivel, elemento, rareza y necesidades.
- Indicador de ventaja o desventaja solo después de conocer al rival.
- Dragones huidos no aparecen como seleccionables.
- Dragones con Vida crítica muestran advertencia.

Botón principal: `Buscar rival`.

## 7.4 Información del rival

Mostrar dos tarjetas enfrentadas:

- Jugador y dragón propio.
- Rival jugador o dragón salvaje.
- Nivel.
- Rareza.
- Elemento.
- Vida, Ataque y Defensa resumidos.
- Relación elemental:
  `Ventaja`, `Neutral` o `Desventaja`.
- Puntos de ranking posibles si es jugador.
- Aclaración `Sin puntos de ranking` si es salvaje.

Botón principal: `Comenzar duelo`.
Botón secundario: `Cambiar dragón`.

## 7.5 Presentación del duelo

- Arena ocupa la pantalla.
- Dragones enfrentados.
- Barras de Vida grandes.
- Número de ronda.
- Texto breve por acción.
- Botón `Acelerar`.
- Botón `Saltar al resultado` después de la primera ronda.
- Máximo 10 rondas.

El jugador no elige ataques. No mostrar botones que sugieran combate en tiempo real.

## 7.6 Resumen de rondas

Durante el combate:

```text
Ronda 3
Brasaloma aprovecha su ventaja elemental.
Daño causado: 18
```

Después:

- Lista colapsable `Ver resumen de rondas`.
- Mostrar daño y ventajas, no fórmulas.

## 7.7 Resultado final

### Victoria

- Fondo dorado suave.
- Dragón celebra según temperamento.
- Mostrar:
  - `Victoria`.
  - Dracoins.
  - XP.
  - Puntos de ranking.
  - Progreso de misión.

### Empate

- Fondo azul plateado.
- Texto: `Duelo equilibrado`.

### Derrota

- Fondo sobrio, nunca humillante.
- Texto: `Tu dragón dio lo mejor de sí`.
- Mostrar XP y Dracoins recibidos.
- Sugerencia útil: alimentar, cuidar o probar otro elemento.

## 7.8 Wireframe textual: vista previa

```text
┌───────────────────────────────────────────────────────────────┐
│ [←] DUELO AUTOMÁTICO                         3/5 con recompensa│
├───────────────────────────┬───────────────────────────────────┤
│ TU DRAGÓN                 │ RIVAL                             │
│ [Brasaloma 3D]            │ [Marealuna 3D]                   │
│ Nivel 5 · Raro · Fuego    │ Nivel 6 · Raro · Agua            │
│ Vida 100 · Atq 29 · Def 23│ Vida 100 · Atq 28 · Def 29       │
│                           │                                   │
│           ⚠ DESVENTAJA ELEMENTAL                             │
│           Victoria posible: 8 puntos                         │
├───────────────────────────┴───────────────────────────────────┤
│ [ Cambiar dragón ]                   [ COMENZAR DUELO ]       │
└───────────────────────────────────────────────────────────────┘
```

## 7.9 Wireframe textual: resultado

```text
┌──────────────────────────────────────────────┐
│                   VICTORIA                   │
│              [Dragón celebrando]             │
├──────────────────────────────────────────────┤
│ +15 DC       +12 XP       +8 Ranking         │
│ Misión “Victoria Mágica” completada          │
├──────────────────────────────────────────────┤
│ [Ver rondas] [Volver] [Otro duelo]           │
└──────────────────────────────────────────────┘
```

---

# 8. Pantalla de ranking

## 8.1 Objetivo

Celebrar participación y progreso comunitario sin generar presión excesiva.

## 8.2 Distribución

- Título: `Ranking de Cuidadores`.
- Tarjeta fija de posición propia.
- Top 3 destacados.
- Lista del resto.
- Explicación accesible de cómo se obtienen puntos.

Cada fila muestra:

- Posición.
- Nombre del jugador.
- Escudo de casa.
- Puntos.
- Victorias.
- Retrato o miniatura del dragón representativo.
- Rareza y elemento mediante iconos.

## 8.3 Comportamiento

- La posición propia permanece visible aunque esté fuera del top mostrado.
- Pulsar una fila abre una tarjeta pública mínima del cuidador y su dragón.
- No mostrar derrotas públicamente.
- Los dragones salvajes no aportan puntos.
- Mostrar texto: “El ranking no se reinicia durante el MVP.”

## 8.4 Wireframe textual

```text
┌────────────────────────────────────────────────────────────┐
│ [←] RANKING DE CUIDADORES                 [¿Cómo funciona?]│
├────────────────────────────────────────────────────────────┤
│ 1  [Dragón] Luna     Ravenclaw      248 pts · 31 victorias│
│ 2  [Dragón] Alex     Gryffindor     221 pts · 28 victorias│
│ 3  [Dragón] Sol      Hufflepuff     198 pts · 26 victorias│
├────────────────────────────────────────────────────────────┤
│ 4  [Dragón] ...                                           │
│ 5  [Dragón] ...                                           │
│ 6  [Dragón] ...                                           │
├────────────────────────────────────────────────────────────┤
│ TU POSICIÓN                                                │
│ 12 [Brasaloma] Tú     Slytherin       84 pts · 11 victorias│
└────────────────────────────────────────────────────────────┘
```

---

# 9. Pantalla de tienda

## 9.1 Objetivo

Permitir compras informadas, evitar errores y mantener visibles las metas de ahorro.

## 9.2 Distribución

Pestañas:

- `Huevos`.
- `Espacios`.
- `Alimentos`.

Cabecera fija:

- Dracoins actuales.
- Espacios usados.

## 9.3 Tienda de huevos

Cada tarjeta muestra:

- Modelo del huevo.
- Nombre.
- Precio.
- Incubación.
- Propósito.
- Probabilidades completas mediante `Ver probabilidades`.
- Aviso si no hay espacio.

Botón:

- `Comprar`.
- `Necesitas espacio`.
- `No disponible` para Constelación.

No presentar Mítico como promesa principal de huevos comprables.

## 9.4 Tienda de espacios

Mostrar:

- Capacidad actual.
- Siguiente capacidad.
- Precio.
- Beneficio claro.
- Progreso hasta máximo 10.

Ejemplo:

> “Amplía tu capacidad de 2 a 3 huevos o dragones.”

Botón: `Comprar espacio por 500 DC`.

## 9.5 Tienda de alimentos

Mostrar:

- Estado actual del dragón seleccionado.
- Beneficios de cada comida.
- Vista previa del resultado.
- Precio.
- Botón `Comprar y alimentar`.

## 9.6 Confirmación de compra

Toda compra muestra:

- Producto.
- Costo.
- Saldo actual.
- Saldo restante.
- Espacio ocupado si aplica.

Botones:

- `Confirmar compra`.
- `Cancelar`.

## 9.7 Wireframe textual

```text
┌──────────────────────────────────────────────────────────────┐
│ [←] TIENDA                         DC 1.240 · Espacios 2/3  │
│ [Huevos] [Espacios] [Alimentos]                             │
├─────────────────────┬─────────────────────┬──────────────────┤
│ HUEVO DEL HOGAR     │ HUEVO ELEMENTAL    │ HUEVO ARCANO     │
│ [modelo]            │ [modelo]           │ [modelo]         │
│ 300 DC · 30 min     │ 650 DC · 2 h       │ 3.000 DC · 24 h │
│ Primer compañero    │ Busca un elemento  │ Meta especial    │
│ [Probabilidades]    │ [Probabilidades]   │ [Probabilidades] │
│ [ COMPRAR ]         │ [ COMPRAR ]        │ [Ahorrar: 1.760] │
└─────────────────────┴─────────────────────┴──────────────────┘
```

---

# 10. Notificaciones

## 10.1 Principios

- Máximo una notificación grande al entrar.
- Agrupar avisos secundarios.
- Las alertas críticas deben explicar la acción recomendada.
- No usar lenguaje culpabilizador.
- Las notificaciones desaparecen automáticamente, pero permanecen en el centro de
  notificaciones.

## 10.2 Niveles

| Nivel | Uso | Tratamiento |
|---|---|---|
| Celebración | Nacimiento, evolución, rareza alta | Modal o ceremonia |
| Acción disponible | Huevo listo, misión completada, caricia disponible | Toast con botón |
| Atención | Hambre o felicidad baja | Aviso ámbar |
| Urgente | Vida muy baja, riesgo de huida | Aviso rojo oscuro persistente |
| Social | Regalo recibido | Toast violeta con botón |

## 10.3 Mensajes

### Huevo listo

> “Tu Huevo Elemental está listo para abrirse.”

Acción: `Presenciar nacimiento`.

### Dragón evolucionado

> “¡Brasaloma ha crecido! Ahora está en etapa Joven.”

Acción: `Ver nueva apariencia`.

### Misión completada

> “Misión completada: Buen Cuidador.”

Acción: `Reclamar`.

### Dragón hambriento

> “Brasaloma tiene hambre. Una comida sencilla lo ayudará.”

Acción: `Alimentar`.

### Felicidad baja

> “Brasaloma parece desanimado. Aliméntalo o acarícialo.”

Acción: `Ver dragón`.

### Dragón a punto de huir

> “Brasaloma necesita atención pronto. Su Vida está muy baja.”

Acción: `Atender ahora`.

Nunca usar: “Tu dragón morirá”.

### Regalo recibido

> “Luna quiere regalarte un Huevo del Emblema Épico.”

Acción: `Ver regalo`.

### Caricia disponible

> “Brasaloma está listo para pasar un momento contigo.”

Acción: `Acariciar`.

### Dracoins insuficientes

> “Necesitas 180 Dracoins más.”

Acción: `Ver misiones`.

### Sin espacio

> “Tus espacios están ocupados. Amplía tu capacidad antes de recibir otro huevo.”

Acción: `Ver espacios`.

## 10.4 Centro de notificaciones

Agrupa:

- Acciones disponibles.
- Regalos.
- Cuidados.
- Celebraciones recientes.

Cada notificación incluye hora relativa y acción. Las ya resueltas quedan atenuadas.

---

# 11. Diseño visual

## 11.1 Dirección artística

Estilo: academia de fantasía mágica inspirada en castillos antiguos, observatorios,
bibliotecas, invernaderos y salas comunes. Debe evocar familiaridad escolar mágica sin
copiar directamente símbolos, interfaces ni recursos visuales de otras franquicias.

La interfaz debe sentirse construida con:

- Pergamino.
- Cuero oscuro.
- Metal dorado envejecido.
- Cristales elementales.
- Tinta mágica.
- Luz cálida de velas.

## 11.2 Paleta base

| Uso | Color sugerido |
|---|---|
| Fondo oscuro | Azul noche `#111827` |
| Panel principal | Pergamino claro `#F3E7C9` |
| Panel oscuro | Carbón azulado `#20283A` |
| Acción principal | Oro cálido `#D5A63C` |
| Acción secundaria | Azul arcano `#496B9B` |
| Texto oscuro | Tinta `#29231D` |
| Texto claro | Marfil `#F7F0DD` |
| Éxito | Verde jade `#4E9A68` |
| Atención | Ámbar `#D89335` |
| Urgente | Carmesí oscuro `#B84747` |

## 11.3 Casas

| Casa | Colores | Símbolo UX | Uso |
|---|---|---|---|
| Gryffindor | Carmesí y oro | Llama coronada | Marcos y detalles de perfil |
| Hufflepuff | Miel y carbón | Brote dorado | Marcos y detalles de perfil |
| Ravenclaw | Zafiro y plata | Estrella alada | Marcos y detalles de perfil |
| Slytherin | Esmeralda y plata | Espiral serpentina | Marcos y detalles de perfil |

Los colores de casa nunca sustituyen colores de estado. Una alerta urgente siempre
debe parecer urgente sin importar la casa.

## 11.4 Rarezas visuales

| Rareza | Color | Tratamiento adicional |
|---|---|---|
| Común | Gris piedra | Marco simple |
| Raro | Azul zafiro | Brillo fino |
| Épico | Violeta | Partículas discretas |
| Legendario | Oro | Marco animado lento |
| Mítico | Iridiscente oscuro | Constelaciones y efecto ceremonial |

Siempre mostrar texto e icono de rareza, no solo color.

## 11.5 Elementos visuales

| Elemento | Icono | Color principal |
|---|---|---|
| Fuego | Llama | Naranja rojizo |
| Agua | Gota | Azul profundo |
| Tierra | Roca/hoja | Verde musgo |
| Aire | Remolino | Celeste |
| Hielo | Cristal | Azul hielo |
| Luz | Estrella | Marfil dorado |
| Sombra | Eclipse | Violeta oscuro |
| Veneno | Colmillo/gota | Verde ácido moderado |

## 11.6 Tipografía

- Títulos: serif fantástica legible, con detalles mínimos.
- Texto de interfaz: sans serif clara.
- Números y temporizadores: sans serif de alta legibilidad.
- No usar tipografías ornamentales en párrafos, botones pequeños o móvil.
- Evitar texto completo en mayúsculas, salvo celebraciones de una palabra.

## 11.7 Iconografía

- Siluetas sólidas y simples.
- Grosor consistente.
- Cada icono siempre acompañado por texto la primera vez.
- Hambre, Felicidad y Vida deben ser inequívocos.
- Evitar iconos demasiado similares para Dracoins y oro decorativo.

## 11.8 Animación y sonido

- Botones: respuesta visual inmediata menor a 150 ms.
- Transiciones de panel: 150-250 ms.
- Celebraciones: más largas, pero omitibles.
- Sonido suave de página para navegación.
- Campanilla para misión completada.
- Chasquido cristalino para Dracoins.
- Reacción sonora distinta por temperamento, sin repetirse constantemente.

---

# 12. Accesibilidad

## 12.1 Tamaños mínimos

| Elemento | Móvil | PC/tablet |
|---|---:|---:|
| Botón táctil | 48 × 48 px equivalentes | 40 × 40 px |
| Botón principal | Altura mínima 52 px | Altura mínima 44 px |
| Texto principal | 18 px equivalentes | 16 px |
| Texto secundario | 16 px equivalentes | 14 px |
| Icono informativo | 24 px | 20 px |

## 12.2 Contraste

- Texto normal: contraste mínimo recomendado 4,5:1.
- Texto grande: mínimo 3:1.
- No colocar texto claro directamente sobre modelos o efectos animados.
- Añadir fondo o sombra sólida bajo texto flotante.
- No usar únicamente rojo y verde para estados opuestos.

## 12.3 Color y comprensión

Cada estado debe comunicar mediante:

1. Icono.
2. Texto.
3. Color.

Ejemplo:

- No mostrar solo una barra roja.
- Mostrar `Vida baja`, icono vital y barra roja.

## 12.4 PC

- Soporte para mouse y teclado.
- Estados hover visibles.
- Escape cierra modal no crítico.
- Enter confirma solo cuando el foco está en la acción principal.
- Mostrar tooltips breves al pasar sobre iconos.

## 12.5 Móvil

- Evitar botones cerca del joystick y salto.
- Barra inferior accesible con pulgar.
- Paneles desplazables verticalmente.
- No exigir arrastrar como única interacción.
- El modelo 3D puede rotarse, pero debe existir acción alternativa.
- Modales no deben cubrir completamente el contexto salvo nacimientos.

## 12.6 Tablet y pantallas variadas

- Usar diseño adaptable, no escalar toda la interfaz como una imagen.
- En pantallas anchas, aprovechar paneles laterales.
- En orientación vertical, priorizar modelo y acción principal.
- Respetar áreas seguras de Roblox.

## 12.7 Mandos

Aunque no sea prioridad inicial:

- Mostrar foco visible.
- Navegación lógica entre controles.
- No depender de cursor preciso.
- Acciones principales accesibles con un botón consistente.

## 12.8 Movimiento y sensibilidad

- Permitir reducir efectos y partículas.
- Evitar destellos rápidos.
- Ceremonias largas deben poder omitirse.
- No mover la cámara bruscamente sin control del jugador.

---

# 13. Wireframes completos

Esta sección resume las pantallas principales y sus estados obligatorios.

## 13.1 Mapa de navegación

```text
Entrada
└── Onboarding
    ├── Vinculación
    ├── Recompensa inicial
    ├── Primera compra
    ├── Incubación
    └── Nacimiento

Inicio
├── Dragones
│   ├── Ficha del dragón
│   ├── Alimentar
│   └── Acariciar
├── Huevos
│   ├── Incubación
│   ├── Nacimiento
│   └── Regalos
├── Misiones
├── Duelo
│   ├── Selección
│   ├── Rival
│   ├── Combate
│   └── Resultado
├── Tienda
│   ├── Huevos
│   ├── Espacios
│   └── Alimentos
├── Ranking
└── Notificaciones
```

## 13.2 Onboarding compacto

```text
┌────────────────────────────────────────┐
│          IMPERIUS DRAGONS              │
│                                        │
│   “Tu vínculo está por comenzar.”      │
│                                        │
│             [ COMENZAR ]               │
│          [Saltar introducción]         │
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│       VINCULA TU CUENTA IMPERIUS       │
│  [ _ ] [ _ ] [ _ ] [ _ ] [ _ ] [ _ ] │
│                                        │
│              [ VINCULAR ]              │
│       [¿Dónde encuentro mi código?]    │
└────────────────────────────────────────┘
```

## 13.3 Inicio

```text
┌──────────────────────────────┐
│ Casa · Nombre       DC 425   │
│                    🔔 2      │
├──────────────────────────────┤
│                              │
│        DRAGÓN EN MUNDO       │
│                              │
│ Brasaloma · Nv.3             │
│ Hambre 42 · Feliz 76 · Vida100│
│ [        ACARICIAR        ]  │
├──────────────────────────────┤
│ Huevo 01:42h · Misión lista  │
├──────────────────────────────┤
│ Inicio Dragón Huevo Misión   │
│            Duelo             │
└──────────────────────────────┘
```

## 13.4 Dragón

```text
┌────────────────────────────────────────┐
│ ← Brasaloma          Acompañante ✓     │
├────────────────────┬───────────────────┤
│                    │ Raro · Fuego      │
│     MODELO 3D      │ Juguetón          │
│                    │ Bebé · Nivel 3    │
│                    │ XP 42/80          │
├────────────────────┴───────────────────┤
│ Hambre 42      [████░░░░░░]            │
│ Felicidad 76   [████████░░]            │
│ Vida 100       [██████████]            │
├────────────────────────────────────────┤
│ [Alimentar] [Acariciar] [Renombrar]    │
└────────────────────────────────────────┘
```

## 13.5 Huevos y regalos

```text
┌────────────────────────────────────────┐
│ ← Huevos       Espacios 2/3 [Tienda]   │
│ [Mis huevos] [Regalos 1]               │
├────────────────────────────────────────┤
│ Huevo Elemental · Raro · Hielo         │
│ [modelo]             Listo             │
│ [Presenciar nacimiento] [Regalar]      │
├────────────────────────────────────────┤
│ Regalo de Luna                         │
│ Huevo del Emblema · Épico              │
│ [Aceptar] [Rechazar]                   │
└────────────────────────────────────────┘
```

## 13.6 Misiones

```text
┌────────────────────────────────────────┐
│ ← Misiones        Reinicio 08:42h      │
│ [Diarias] [Semanales] [Especiales]     │
├────────────────────────────────────────┤
│ Buen Cuidador                   1/1     │
│ [████████████] 15 DC · 8 XP             │
│                         [RECLAMAR]      │
├────────────────────────────────────────┤
│ Aprendiz de Duelista            1/3    │
│ [████░░░░░░░░] 35 DC · 15 XP            │
│                    [Ver objetivo]       │
└────────────────────────────────────────┘
```

## 13.7 Duelo

```text
┌────────────────────────────────────────┐
│ ← Duelo                3/5 recompensas │
├───────────────────┬────────────────────┤
│ TU DRAGÓN         │ RIVAL              │
│ Brasaloma Nv.5    │ Marealuna Nv.6     │
│ Raro · Fuego      │ Raro · Agua        │
├───────────────────┴────────────────────┤
│       ⚠ DESVENTAJA ELEMENTAL           │
│       Victoria: hasta 8 puntos         │
│ [Cambiar dragón] [COMENZAR DUELO]      │
└────────────────────────────────────────┘
```

## 13.8 Ranking

```text
┌────────────────────────────────────────┐
│ ← Ranking            [¿Cómo funciona?] │
├────────────────────────────────────────┤
│ 1 Luna     248 pts [Oráculo Zafiro]    │
│ 2 Alex     221 pts [Leonis Rubra]      │
│ 3 Sol      198 pts [Melidor Áureo]     │
├────────────────────────────────────────┤
│ Tú · Posición 12 · 84 pts              │
└────────────────────────────────────────┘
```

## 13.9 Tienda

```text
┌────────────────────────────────────────┐
│ ← Tienda       DC 1.240 · Espacios 2/3│
│ [Huevos] [Espacios] [Alimentos]        │
├────────────────────────────────────────┤
│ Huevo del Hogar                        │
│ 300 DC · 30 minutos                    │
│ [Probabilidades] [COMPRAR]             │
├────────────────────────────────────────┤
│ Huevo Arcano                           │
│ 3.000 DC · 24 horas                    │
│ [Probabilidades] [Faltan 1.760 DC]     │
└────────────────────────────────────────┘
```

## 13.10 Confirmación universal

```text
┌────────────────────────────────────────┐
│          CONFIRMAR COMPRA              │
│ Huevo del Hogar                        │
│                                        │
│ Costo:            300 DC               │
│ Saldo actual:     400 DC               │
│ Saldo restante:   100 DC               │
│ Ocupará:          1 espacio            │
│                                        │
│ [Cancelar]          [CONFIRMAR]         │
└────────────────────────────────────────┘
```

## 13.11 Nacimiento

```text
┌────────────────────────────────────────┐
│                                        │
│          [HUEVO / DRAGÓN 3D]           │
│                                        │
│             HA NACIDO                  │
│             BRASALOMA                  │
│                                        │
│       Raro · Fuego · Juguetón          │
│                                        │
│ Nombre: [________________________]      │
│                                        │
│         [ CONOCER A MI DRAGÓN ]        │
└────────────────────────────────────────┘
```

## 13.12 Centro de notificaciones

```text
┌────────────────────────────────────────┐
│ ← NOTIFICACIONES                 [✓]   │
│ [Acciones] [Regalos] [Historial]       │
├────────────────────────────────────────┤
│ 🥚 Tu Huevo Elemental está listo       │
│ Hace 3 min                  [Abrir]     │
├────────────────────────────────────────┤
│ 🎁 Luna quiere regalarte un huevo      │
│ Hace 12 min              [Ver regalo]  │
├────────────────────────────────────────┤
│ 🍖 Brasaloma tiene hambre              │
│ Hace 1 h                  [Alimentar]   │
├────────────────────────────────────────┤
│ ✓ Misión “Buen Cuidador” reclamada     │
│ Ayer                                   │
└────────────────────────────────────────┘
```

## 13.13 Compra de espacio

```text
┌────────────────────────────────────────┐
│ ← ESPACIOS DE DRAGÓN                   │
├────────────────────────────────────────┤
│ Capacidad actual                       │
│ 2 de 10 espacios desbloqueados         │
│ [■■□□□□□□□□]                            │
│                                        │
│ Siguiente espacio                      │
│ Capacidad: 2 → 3                       │
│ Costo: 500 DC                          │
│                                        │
│ [ COMPRAR ESPACIO ]                    │
└────────────────────────────────────────┘
```

---

# 14. Prioridad de desarrollo

## 14.1 Imprescindibles para una demo funcional

Construir primero:

1. Entrada y vinculación.
2. Recompensa inicial.
3. Tienda simplificada del primer Huevo del Hogar.
4. Pantalla de huevos e incubación.
5. Nacimiento.
6. Pantalla del dragón.
7. Selección como acompañante.
8. Inicio con estado del dragón.
9. Alimentación.
10. Caricia.

La demo funcional mínima termina cuando un jugador puede vincularse, comprar, incubar,
conocer, seleccionar, alimentar y acariciar a su primer dragón.

## 14.2 Segunda prioridad: loop jugable completo

Construir después:

1. Misiones diarias y reclamo.
2. Selección de dragón para duelo.
3. Vista previa de rival.
4. Presentación automática del combate.
5. Resultado y recompensas.
6. Ranking.
7. Tienda completa de huevos, espacios y alimentos.

## 14.3 Tercera prioridad: comunidad y profundidad

Pueden esperar hasta que el loop principal sea estable:

1. Regalos de huevos.
2. Misiones semanales y especiales.
3. Centro de notificaciones completo.
4. Perfil público desde ranking.
5. Variantes visuales elaboradas por rareza.
6. Ceremonia comunitaria de nacimiento Mítico.

## 14.4 Orden recomendado por entregables

| Entrega | Pantallas |
|---|---|
| Prototipo de vínculo | Entrada, Vinculación, Recompensa |
| Prototipo emocional | Compra inicial, Huevos, Nacimiento, Dragón |
| Demo funcional | Inicio, Alimentar, Acariciar, Acompañante |
| MVP jugable | Misiones, Duelo, Resultado, Tienda |
| MVP comunitario | Ranking, Regalos, Notificaciones |
| Pulido de lanzamiento | Accesibilidad, adaptación multiplataforma, animaciones y sonido |

## 14.5 Criterio de calidad antes de avanzar

No construir la siguiente capa hasta que:

- La acción principal de cada pantalla se entienda en menos de 5 segundos.
- Un jugador nuevo complete el flujo sin explicación verbal externa.
- En móvil no haya botones bloqueados por controles Roblox.
- Ninguna compra pueda confirmarse accidentalmente.
- Hambre, Felicidad y Vida se distingan sin depender solo de color.
- El jugador recuerde cómo se llama su dragón después de la primera sesión.
