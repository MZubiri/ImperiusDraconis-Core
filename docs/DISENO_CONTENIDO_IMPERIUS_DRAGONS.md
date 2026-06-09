# Imperius Dragons

> **Estado documental:** diseño de contenido futuro. La mayoria de estos sistemas no
> esta implementada. Consultar [`game-design-document.md`](game-design-document.md)
> para conocer el estado real.

## Game Content Design del MVP

**Versión:** 1.1

**Fecha:** 9 de junio de 2026

**Objetivo del documento:** definir el contenido, fantasía, balance y experiencia de
juego inicial para sesiones de 5 a 15 minutos.

---

# 1. Visión del juego

## 1.1 Concepto

Imperius Dragons es una experiencia de fantasía escolar mágica donde cada integrante
de la comunidad Imperius forma un vínculo con dragones únicos. El jugador no es un
conquistador de criaturas: es su cuidador, compañero y representante en pequeños
duelos mágicos.

La experiencia combina:

- El misterio de abrir huevos mágicos.
- El apego de cuidar una criatura que cambia con el tiempo.
- El orgullo de mostrar un dragón representativo de la personalidad o casa del jugador.
- La satisfacción de completar objetivos breves y mejorar una colección.
- La emoción de enfrentar otros dragones y descubrir criaturas salvajes.

## 1.2 Fantasía principal

> “Soy un aprendiz de la comunidad Imperius que ha recibido la responsabilidad de
> criar, cuidar y entrenar dragones mágicos.”

El dragón debe sentirse como una mascota viva, no como una simple carta de combate.
Su temperamento, necesidades, crecimiento y apariencia crean una historia personal.

## 1.3 Objetivo del jugador

El objetivo a corto plazo es cuidar al dragón, completar misiones y ganar Dracoins.
El objetivo a mediano plazo es llevarlo hasta adulto, mejorar el ranking y ampliar la
colección. El objetivo emocional de largo plazo es encontrar “mi dragón”: la especie,
rareza y temperamento con los que el jugador se identifica.

## 1.4 Pilares de diseño

| Pilar | Promesa |
|---|---|
| Vínculo | El dragón responde al cuidado y acompaña al jugador |
| Descubrimiento | Cada huevo puede revelar una especie, rareza y temperamento especial |
| Progreso breve | Cada sesión permite completar algo útil |
| Identidad | Casas, elementos y dragones expresan personalidad |
| Comunidad | Los jugadores comparan dragones, compiten y regalan huevos |

## 1.5 Loop de sesión

Una sesión típica de 5 a 15 minutos:

1. Saludar y revisar el estado del dragón.
2. Alimentarlo si tiene hambre.
3. Revisar huevos o regalos pendientes.
4. Completar una o dos misiones.
5. Realizar uno a tres duelos automáticos.
6. Reclamar recompensas.
7. Ahorrar para un huevo o espacio nuevo.

## 1.6 Loop emocional

```text
Curiosidad
→ “¿Qué dragón nacerá?”
→ Apego
→ “Necesita que lo cuide”
→ Orgullo
→ “Creció y se ve distinto”
→ Emoción
→ “Puede vencer a ese rival”
→ Recompensa
→ “Estoy más cerca de mi próximo huevo”
→ Nueva curiosidad
```

## 1.7 Tono

- Mágico, cálido y ligeramente misterioso.
- Competitivo sin ser agresivo.
- El fracaso debe motivar cuidado y mejora, no castigar duramente.
- Los dragones nunca mueren. Si son abandonados durante demasiado tiempo, huyen.
- La rareza debe emocionar, pero un dragón común bien cuidado sigue siendo valioso.

---

# 2. Sistema de rarezas

## 2.1 Principios

- La rareza representa escasez, detalle visual y prestigio.
- La rareza no aplica un multiplicador directo de poder.
- Las especies raras pueden tener perfiles estadísticos más especializados, pero
  siempre conservan debilidades.
- La rareza del huevo se conserva al regalarlo y pasa al dragón al incubar.
- Los dragones míticos deben ser celebraciones extraordinarias, no requisitos para
  competir.

## 2.2 Rarezas y probabilidades globales sugeridas

Estas probabilidades representan la distribución objetivo general. Cada tipo de huevo
utiliza su propia tabla.

| Rareza | Probabilidad global objetivo | Identidad visual | Rol |
|---|---:|---|---|
| Común | 60 % | Materiales naturales, silueta sencilla | Primeros compañeros y colección base |
| Raro | 25 % | Colores intensos, cuernos o alas distintivas | Especialización visible |
| Épico | 10 % | Brillos elementales y accesorios naturales | Prestigio accesible a mediano plazo |
| Legendario | 4 % | Aura propia, animación especial y gran silueta | Meta coleccionable |
| Mítico | Menor a 0,1 % de todos los nacimientos | Efectos únicos, aparición ceremonial | Acontecimiento comunitario |

La rareza Mítica no debe entenderse como una probabilidad normal disponible en todo
momento. Su frecuencia real depende de dos barreras: la probabilidad dentro del huevo
y la disponibilidad limitada de Huevos de la Constelación. El objetivo de lanzamiento
es que puedan pasar semanas sin que nazca un mítico en toda la comunidad.

Cuando nazca uno, se recomienda mostrar un anuncio ceremonial no invasivo dentro del
juego, siempre que su propietario permita compartirlo.

## 2.3 Valor de rareza para ranking

La rareza del rival aumenta el valor de una victoria:

| Rareza rival | Bono de ranking |
|---|---:|
| Común | 0 |
| Raro | +2 |
| Épico | +3 |
| Legendario | +4 |
| Mítico | +5 |

Los dragones salvajes no otorgan puntos de ranking, independientemente de su rareza.

---

# 3. Huevos

## 3.1 Principios

- Cada huevo ocupa un espacio de dragón.
- El huevo muestra tipo y rareza, pero no revela necesariamente la especie.
- El tiempo de incubación crea anticipación sin bloquear sesiones completas.
- Los huevos pueden regalarse antes de abrirse.
- El resultado del huevo debe sentirse coherente con su apariencia.
- Primero se determina la rareza visible del huevo. Al incubar, nace una especie
  disponible de esa misma rareza dentro del pool del huevo.

## 3.2 Catálogo inicial

| Huevo | Costo | Incubación | Común | Raro | Épico | Legendario | Mítico |
|---|---:|---:|---:|---:|---:|---:|---:|
| Huevo del Hogar | 300 DC | 30 min | 75 % | 20 % | 4,5 % | 0,5 % | 0 % |
| Huevo Elemental | 650 DC | 2 h | 40 % | 40 % | 16 % | 3,999 % | 0,001 % |
| Huevo del Emblema | 900 DC | 4 h | 15 % | 45 % | 32 % | 7,99 % | 0,01 % |
| Huevo Arcano | 3.000 DC | 24 h | 2 % | 25 % | 45 % | 27,9 % | 0,1 % |
| Huevo de la Constelación | No se vende | 24 h | 0 % | 5 % | 30 % | 62 % | 3 % |

### Lectura de las nuevas probabilidades

- El Huevo del Hogar jamás entrega míticos.
- El Huevo Elemental tiene una posibilidad de `0,001 %`, equivalente a 1 entre 100.000.
- El Huevo del Emblema conserva una posibilidad testimonial de `0,01 %`.
- El Huevo Arcano ofrece `0,1 %`, equivalente a 1 entre 1.000, y además requiere una
  inversión importante.
- El Huevo de la Constelación es la fuente principal con `3 %`, pero solo se obtiene
  mediante hitos y eventos limitados.

El resultado esperado es que comprar huevos normales no sea una estrategia razonable
para buscar míticos. Los jugadores persiguen Constelaciones mediante logros especiales,
y un nacimiento mítico se convierte en un acontecimiento comunitario.

## 3.3 Tipos y apariencia

### Huevo del Hogar

- **Propósito:** primer huevo y opción económica.
- **Apariencia:** cáscara crema, vetas cobrizas y brillo cálido tenue.
- **Pool principal:** Brasaloma, Rocamusgo y especies raras ocasionales.
- **Sensación:** familiar, seguro y acogedor.

### Huevo Elemental

- **Propósito:** permitir buscar un elemento concreto.
- **Variantes:** Fuego, Agua, Tierra, Aire, Hielo, Luz, Sombra y Veneno.
- **Apariencia:** cáscara del color elemental con partículas suaves.
- **Pool principal:** especies del elemento elegido.
- **Sensación:** elección y especialización.

### Huevo del Emblema

- **Propósito:** celebrar la identidad de casa del jugador.
- **Variantes:** Gryffindor, Hufflepuff, Ravenclaw y Slytherin.
- **Apariencia:** esmalte en colores de la casa y sello mágico frontal.
- **Pool principal:** al obtener la rareza correspondiente, prioriza el dragón
  representativo de la casa; en otras rarezas entrega especies compatibles con sus
  valores.
- **Sensación:** pertenencia y orgullo.

### Huevo Arcano

- **Propósito:** gran objetivo de ahorro y celebración personal.
- **Apariencia:** cáscara violeta oscura, runas móviles y grietas luminosas.
- **Pool principal:** todas las especies, con énfasis en épicas y legendarias.
- **Sensación:** misterio y posibilidad extraordinaria. Su incubación de 24 horas debe
  incluir cambios visuales progresivos en las runas.

### Huevo de la Constelación

- **Propósito:** recompensa especial por hitos o eventos.
- **Apariencia:** negro azulado con estrellas que se desplazan sobre la superficie.
- **Pool principal:** especies épicas, legendarias y míticas.
- **Sensación:** ceremonia y celebración.

## 3.4 Regalos

Regalar huevos debe sentirse como un gesto social valioso:

- El huevo conserva tipo, rareza y tiempo de incubación.
- El destinatario debe aceptar el regalo.
- No existe costo por regalar.
- No se pueden regalar dragones nacidos.
- Las misiones de regalo deben ser ocasionales para no presionar a gastar.

## 3.5 Impacto económico de la rareza Mítica

- Los huevos comprables no ofrecen una ruta eficiente para buscar míticos.
- El Arcano funciona principalmente como objetivo para épicos y legendarios.
- El Huevo de la Constelación debe entregarse de forma limitada: hitos únicos, eventos
  especiales o reconocimientos comunitarios.
- Como guía inicial, no entregar más de `5` Huevos de la Constelación al mes a toda la
  comunidad, sin contar recompensas únicas de bienvenida futura.
- No se recomienda vender Huevos de la Constelación ni aumentar probabilidades de
  míticos durante promociones.

Con cinco Constelaciones mensuales y una probabilidad Mítica de `3 %`, el valor esperado
es aproximadamente un nacimiento mítico cada seis o siete meses desde esta fuente.
Los nacimientos accidentales de otros huevos son todavía menos frecuentes.

---

# 4. Elementos

## 4.1 Reglas de combate elemental

- Ventaja: `+15 %` al daño causado.
- Desventaja: `-15 %` al daño causado.
- Relación neutral: sin cambio.
- No se acumulan múltiples ventajas.
- El elemento aporta estrategia, pero no decide el combate por sí solo.

## 4.2 Tabla elemental

| Elemento | Fuerte contra | Débil contra | Fantasía |
|---|---|---|---|
| Fuego | Tierra, Hielo | Agua, Aire | Pasión, valor y poder explosivo |
| Agua | Fuego, Veneno | Tierra, Hielo | Adaptación, paciencia y fluidez |
| Tierra | Aire, Veneno | Fuego, Agua | Fortaleza, lealtad y resistencia |
| Aire | Agua, Luz | Tierra, Hielo | Libertad, velocidad e ingenio |
| Hielo | Agua, Aire | Fuego, Luz | Control, precisión y serenidad |
| Luz | Hielo, Sombra | Aire, Veneno | Protección, esperanza y revelación |
| Sombra | Luz, Fuego | Luz, Veneno | Sigilo, ambición y misterio |
| Veneno | Luz, Sombra | Agua, Tierra | Astucia, desgaste y oportunidad |

Luz y Sombra son fuertes entre sí. Sus enfrentamientos deben sentirse inestables y
peligrosos para ambos.

---

# 5. Las 10 especies iniciales

## 5.1 Escala de estadísticas

Las estadísticas base representan el perfil natural de la especie antes de nivel,
etapa, necesidades y temperamento.

| Estadística | Rango habitual |
|---|---:|
| Vida | 85-120 |
| Ataque | 19-35 |
| Defensa | 18-34 |

La rareza no multiplica estas estadísticas. Cada especie conserva una fortaleza y una
debilidad clara.

## 5.2 Catálogo

### 1. Brasaloma

| Campo | Diseño |
|---|---|
| Rareza | Común |
| Elemento | Fuego |
| Estadísticas | Vida 90, Ataque 25, Defensa 20 |
| Historia | Anida cerca de chimeneas y ayuda a mantener calientes las salas de estudio durante noches frías. |
| Personalidad | Entusiasta, sociable y algo impaciente. |
| Apariencia | Dragón pequeño rojizo, pecho crema, cola con brasa suave y alas redondeadas. |
| Rol | Atacante inicial equilibrado y fácil de entender. |

### 2. Rocamusgo

| Campo | Diseño |
|---|---|
| Rareza | Común |
| Elemento | Tierra |
| Estadísticas | Vida 110, Ataque 19, Defensa 28 |
| Historia | Se camufla entre jardines antiguos y protege nidos de criaturas pequeñas. |
| Personalidad | Paciente, protector y dormilón. |
| Apariencia | Escamas de piedra gris, musgo sobre el lomo y pequeños brotes en los cuernos. |
| Rol | Defensor inicial resistente. |

### 3. Marealuna

| Campo | Diseño |
|---|---|
| Rareza | Raro |
| Elemento | Agua |
| Estadísticas | Vida 100, Ataque 23, Defensa 25 |
| Historia | Solo aparece en lagos donde la luna puede reflejarse sin interrupciones. |
| Personalidad | Tranquila, sensible y muy observadora. |
| Apariencia | Escamas azul perla, aletas translúcidas y marcas plateadas en forma de ondas. |
| Rol | Perfil equilibrado con buena supervivencia. |

### 4. Cierzoazul

| Campo | Diseño |
|---|---|
| Rareza | Raro |
| Elemento | Aire |
| Estadísticas | Vida 85, Ataque 30, Defensa 18 |
| Historia | Recorre torres y tejados persiguiendo corrientes mágicas invisibles. |
| Personalidad | Curioso, inquieto y difícil de sorprender. |
| Apariencia | Cuerpo delgado azul cielo, alas largas y plumas mágicas en la cola. |
| Rol | Atacante rápido y frágil. |

### 5. Escarchaleta

| Campo | Diseño |
|---|---|
| Rareza | Raro |
| Elemento | Hielo |
| Estadísticas | Vida 95, Ataque 27, Defensa 23 |
| Historia | Conserva cartas y recuerdos dentro de pequeños cristales de hielo que nunca se derriten. |
| Personalidad | Reservada, precisa y profundamente leal. |
| Apariencia | Escamas blancas y celestes, alas cristalinas y aliento de nieve brillante. |
| Rol | Atacante equilibrado con defensa media. |

### 6. Leonis Rubra, Guardián de Gryffindor

| Campo | Diseño |
|---|---|
| Rareza | Épico |
| Elemento | Fuego |
| Estadísticas | Vida 105, Ataque 32, Defensa 24 |
| Historia | Según la tradición, aparece cuando alguien actúa con valentía para proteger a otro. |
| Personalidad | Valiente, orgulloso y protector. |
| Apariencia | Escamas carmesí, melena dorada de fuego y cuernos semejantes a una corona. |
| Rol | Atacante fuerte con vida suficiente para resistir. |

### 7. Melidor Áureo, Guardián de Hufflepuff

| Campo | Diseño |
|---|---|
| Rareza | Épico |
| Elemento | Tierra |
| Estadísticas | Vida 120, Ataque 23, Defensa 34 |
| Historia | Cuida huertos mágicos y comparte su calor con cualquier criatura que busque refugio. |
| Personalidad | Leal, trabajador y afectuoso. |
| Apariencia | Cuerpo robusto, escamas miel y negras, garras doradas y flores pequeñas en el lomo. |
| Rol | Gran defensor con daño moderado. |

### 8. Viperumbra Esmeralda, Guardián de Slytherin

| Campo | Diseño |
|---|---|
| Rareza | Épico |
| Elemento | Veneno |
| Estadísticas | Vida 90, Ataque 35, Defensa 20 |
| Historia | Habita pasadizos ocultos y reconoce a quienes saben esperar el momento correcto. |
| Personalidad | Ambicioso, astuto y selectivo con su confianza. |
| Apariencia | Silueta serpentina, escamas verde oscuro, ojos plateados y vapor esmeralda. |
| Rol | Mayor ataque inicial a cambio de fragilidad. |

### 9. Oráculo Zafiro, Guardián de Ravenclaw

| Campo | Diseño |
|---|---|
| Rareza | Legendario |
| Elemento | Luz |
| Estadísticas | Vida 100, Ataque 31, Defensa 29 |
| Historia | Se dice que sus escamas muestran constelaciones distintas cuando alguien descubre una idea importante. |
| Personalidad | Sabio, curioso y enigmático. |
| Apariencia | Escamas azul zafiro, alas con constelaciones y halo plateado alrededor de los cuernos. |
| Rol | Perfil avanzado equilibrado y flexible. |

### 10. Eclipse Primordial

| Campo | Diseño |
|---|---|
| Rareza | Mítico |
| Elemento | Sombra |
| Estadísticas | Vida 110, Ataque 34, Defensa 31 |
| Historia | Una criatura casi olvidada que despierta cuando una estrella desaparece del cielo mágico. |
| Personalidad | Silencioso, independiente y sorprendentemente protector. |
| Apariencia | Escamas negras con bordes violetas, interior de alas estrellado y aura de eclipse. |
| Rol | Perfil fuerte y completo, pero vulnerable a Luz y Veneno. |

## 5.3 Representantes de casas

| Casa | Dragón | Valor representado |
|---|---|---|
| Gryffindor | Leonis Rubra | Valentía |
| Hufflepuff | Melidor Áureo | Lealtad |
| Ravenclaw | Oráculo Zafiro | Sabiduría |
| Slytherin | Viperumbra Esmeralda | Ambición |

## 5.4 Bonificaciones permanentes de casas

Las bonificaciones propuestas son adecuadas si se aplican a fuentes concretas y no
afectan combate, ranking ni probabilidades de huevo. Expresan la identidad de cada
casa sin convertir una elección social en una ventaja dominante.

| Casa | Bonificación recomendada | Alcance y límite |
|---|---|---|
| Gryffindor | +5 % experiencia de combates | Solo XP de duelos; no aumenta Dracoins ni ranking |
| Hufflepuff | +5 % felicidad obtenida | Aplica a comida y caricias |
| Ravenclaw | +5 % experiencia de misiones | Solo XP al reclamar misiones |
| Slytherin | +5 % Dracoins de combates | Solo los primeros 5 duelos recompensados; máximo +5 DC diarios |

### Validación de balance

- Gryffindor progresa algo más rápido mediante duelos.
- Ravenclaw progresa algo más rápido mediante objetivos.
- Hufflepuff obtiene comodidad de cuidado, pero no poder directo.
- Slytherin obtiene una ventaja económica pequeña y limitada. El tope diario evita
  inflación acumulativa y mantiene las demás casas competitivas.
- Ninguna casa aumenta estadísticas, rareza, probabilidades, puntos de ranking o
  recompensas especiales.
- Las fracciones generadas por el `5 %` se acumulan para la siguiente recompensa de la
  misma categoría hasta formar una unidad completa. Así el bono nunca se redondea a
  cero ni entrega más de lo prometido.

No se recomienda sustituir estos bonos por ventajas elementales o estadísticas de
combate: eso convertiría la casa en una decisión obligatoria para competir.

---

# 6. Temperamentos

## 6.1 Objetivo

El temperamento convierte dos dragones de la misma especie en compañeros ligeramente
distintos. Sus efectos son pequeños, claros y nunca superan `±5 %`.

## 6.2 Temperamentos iniciales

| Temperamento | Probabilidad | Efecto | Comportamiento visible |
|---|---:|---|---|
| Noble | 20 % | +3 % Defensa | Mantiene postura erguida y saluda al acercarse |
| Agresivo | 20 % | +5 % Ataque, -3 % Defensa | Gruñe y despliega las alas antes de combatir |
| Juguetón | 20 % | +5 % Felicidad obtenida al alimentar | Da pequeños saltos y gira alrededor del jugador |
| Curioso | 20 % | +3 % Experiencia obtenida | Observa objetos y ladea la cabeza |
| Perezoso | 20 % | -5 % pérdida de Hambre, -2 % Ataque | Se sienta o duerme cuando el jugador se detiene |

No se necesitan temperamentos adicionales para el lanzamiento. La variedad proviene
de combinar especie, rareza, elemento y estos cinco perfiles.

---

# 7. Alimentación

## 7.1 Principios

- La comida básica mantiene al dragón saludable.
- La comida especial permite resolver necesidades concretas.
- Alimentar nunca debe ser un castigo económico severo.
- Los alimentos se compran y consumen en el momento durante el MVP.

## 7.2 Alimentos básicos

| Alimento | Costo | Hambre | Felicidad | Vida | XP | Descripción |
|---|---:|---:|---:|---:|---:|---|
| Bocado de Granero | 8 DC | +20 | 0 | 0 | 0 | Mezcla sencilla para cuidado diario |
| Pez Plateado | 12 DC | +30 | 0 | 0 | 0 | Favorito de dragones de Agua y Hielo |
| Fruta Solar | 15 DC | +20 | +5 | 0 | 0 | Fruta tibia que mejora el ánimo |
| Raíz Crujiente | 18 DC | +35 | +3 | 0 | 0 | Alimento abundante de los jardines mágicos |

## 7.3 Alimentos especiales

| Alimento | Costo | Hambre | Felicidad | Vida | XP | Uso |
|---|---:|---:|---:|---:|---:|---|
| Banquete Dracónico | 35 DC | +60 | +10 | +5 | 0 | Recuperación completa tras varios días |
| Cristal de Miel | 45 DC | +10 | +25 | 0 | 0 | Recuperar felicidad |
| Elixir Vital | 70 DC | +5 | +5 | +25 | 0 | Evitar que un dragón debilitado huya |
| Baya Estelar | 90 DC | +20 | +10 | 0 | +10 | Apoyar crecimiento y experiencia |

## 7.4 Ritmo de necesidades

| Regla | Valor inicial |
|---|---:|
| Hambre al nacer | 80 |
| Felicidad al nacer | 80 |
| Vida al nacer | 100 |
| Pérdida de Hambre | 1 cada 2 horas |
| Umbral de Hambre baja | Menor a 30 |
| Pérdida de Felicidad con Hambre baja | 1 cada 4 horas |
| Umbral crítico de Felicidad | Menor a 20 |
| Pérdida de Vida con Felicidad crítica | 1 cada 6 horas |
| Vida en 0 | El dragón huye |

Este ritmo permite varios días sin entrar antes de que el dragón sufra consecuencias
serias. El objetivo es incentivar visitas, no generar ansiedad.

## 7.5 Sistema de caricias

Las caricias ofrecen una interacción afectiva breve, gratuita y separada de la
economía.

| Regla | Valor recomendado |
|---|---:|
| Costo | Gratis |
| Cooldown | 4 horas por jugador |
| Dragón afectado | Acompañante seleccionado |
| Felicidad obtenida | +6 |
| Probabilidad de experiencia | 15 % |
| Experiencia excepcional | +3 XP |
| Límite práctico | Hasta 6 caricias diarias si se respetan todos los cooldowns |

El cooldown es por jugador, no por dragón. Así se incentivan varias visitas sin
convertir una colección grande en una granja de experiencia.

La caricia no recupera Hambre ni Vida, no entrega Dracoins y no sustituye la
alimentación. Hufflepuff obtiene `+5 %` de felicidad, aplicado antes de limitar el
resultado a 100.

### Presentación sugerida

- Animación breve de mano o destello mágico sobre la cabeza.
- El dragón responde según su temperamento.
- Corazones o partículas suaves durante menos de dos segundos.
- Mostrar el tiempo restante cuando aún está en cooldown.

Mensajes sugeridos:

| Situación | Mensaje |
|---|---|
| Caricia normal | “Tu dragón se acerca con confianza. Felicidad +6.” |
| Con experiencia | “Un vínculo especial se fortalece. Felicidad +6, Experiencia +3.” |
| Cooldown | “Tu dragón está descansando. Podrás acariciarlo de nuevo en {tiempo}.” |
| Noble | “Inclina la cabeza con elegancia.” |
| Agresivo | “Finge resistirse, pero termina acercándose.” |
| Juguetón | “Da una vuelta feliz alrededor de ti.” |
| Curioso | “Observa tu mano como si escondiera un secreto.” |
| Perezoso | “Cierra los ojos y se acomoda a tu lado.” |

---

# 8. Crecimiento

## 8.1 Etapas

| Etapa | Identidad | Escala visual | Modificador de combate |
|---|---|---:|---:|
| Bebé | Dependiente, expresivo y fácil de cuidar | 65 % | 75 % |
| Joven | Más seguro, activo y listo para duelos | 85 % | 100 % |
| Adulto | Forma completa y presencia imponente | 100 % | 120 % |

## 8.2 Requisitos

| Evolución | Tiempo mínimo | XP total requerida | Vida mínima | Felicidad mínima |
|---|---:|---:|---:|---:|
| Bebé → Joven | 24 horas desde nacimiento | 80 XP | 50 | 30 |
| Joven → Adulto | 72 horas desde etapa Joven | 250 XP | 60 | 40 |

El crecimiento ocurre al cumplir todos los requisitos. No tiene costo en Dracoins.

## 8.3 Nivel

- Nivel inicial: `1`.
- Nivel máximo MVP: `20`.
- Cada nivel por encima de 1 aumenta Vida, Ataque y Defensa en `2 %` respecto a sus
  valores base.
- La experiencia proviene principalmente de misiones y duelos.
- Alcanzar Adulto debe tomar aproximadamente de 5 a 8 días para un jugador activo.

---

# 9. Misiones

## 9.1 Diseño general

- Las misiones deben orientar al jugador hacia el loop, no obligarlo a jugar durante
  horas.
- Una sesión corta debe completar al menos una misión.
- Las misiones diarias pueden completarse en 5 a 15 minutos.
- Las misiones semanales recompensan constancia.
- Las misiones especiales celebran hitos personales y comunitarios.

## 9.2 Misiones diarias

Se ofrecen tres misiones diarias. El conjunto debe evitar exigir gasto alto todos los
días.

| Misión | Objetivo | Recompensa |
|---|---|---|
| Buen Cuidador | Alimenta a un dragón 1 vez | 15 DC, 8 XP |
| Ánimo Radiante | Lleva la Felicidad de un dragón a 70 o más | 15 DC, 8 XP |
| Primer Duelo del Día | Completa 1 duelo | 20 DC, 8 XP |
| Aprendiz de Duelista | Completa 3 duelos | 35 DC, 15 XP |
| Victoria Mágica | Gana 1 duelo contra jugador | 30 DC, 15 XP |
| Encuentro Salvaje | Vence 1 dragón salvaje | 25 DC, 12 XP |
| Alimentación Generosa | Recupera 50 puntos de Hambre en total | 25 DC, 12 XP |

## 9.3 Misiones semanales

Se ofrecen dos misiones semanales elegidas entre las siguientes:

| Misión | Objetivo | Recompensa |
|---|---|---|
| Guardián Constante | Alimenta dragones en 4 días distintos | 120 DC, 35 XP |
| Duelista de la Academia | Completa 12 duelos | 160 DC, 50 XP |
| Racha Victoriosa | Gana 5 duelos contra jugadores | 180 DC, 60 XP |
| Explorador de lo Salvaje | Vence 5 tipos de dragón salvaje | 180 DC, 50 XP |
| Lazos de Amistad | Regala y consigue que acepten 1 huevo | 80 DC, 20 XP |
| Compañero Feliz | Mantén un dragón con Felicidad 70 o más durante 3 días | 150 DC, 45 XP |

## 9.4 Misiones especiales

Estas misiones se completan una sola vez.

| Misión | Objetivo | Recompensa |
|---|---|---|
| Bienvenido a Imperius Dragons | Vincula tu cuenta | 400 DC |
| Primer Latido | Incuba tu primer huevo | 75 DC, 25 XP |
| Primer Vínculo | Selecciona tu primer acompañante | 25 DC |
| Alas Jóvenes | Lleva un dragón a etapa Joven | 100 DC, 30 XP |
| Guardián Adulto | Lleva un dragón a etapa Adulto | 200 DC, 75 XP |
| Coleccionista Novato | Consigue 3 dragones | 200 DC |
| Espíritu Generoso | Completa tu primer regalo de huevo | 50 DC |
| Diez Victorias | Gana 10 duelos contra jugadores | 250 DC |
| Encuentro con el Eclipse | Vence a un dragón salvaje Legendario | Huevo de la Constelación |

---

# 10. Dragones salvajes

## 10.1 Función

Los dragones salvajes aseguran que siempre exista un combate disponible. También
permiten mostrar criaturas que el jugador aún no posee y contar pequeñas historias
del mundo.

No otorgan puntos de ranking. Sí entregan Dracoins y experiencia.

## 10.2 Catálogo inicial

| Dragón salvaje | Elemento | Rareza | Nivel | Perfil | Apariencia e historia |
|---|---|---|---:|---|---|
| Chispero del Bosque | Fuego | Común | 1-3 | Ataque ligero | Pequeño dragón rojizo que enciende hojas secas al estornudar |
| Lodocorno del Invernadero | Tierra | Común | 1-4 | Defensa alta | Criatura cubierta de barro y raíces que protege jardines |
| Aletilla del Arroyo | Agua | Común | 2-5 | Equilibrado | Dragón anfibio azul que colecciona objetos brillantes |
| Vendaval Errante | Aire | Raro | 3-7 | Ataque alto | Silueta veloz que recorre torres durante tormentas |
| Colmillo de Escarcha | Hielo | Raro | 4-8 | Equilibrado | Cazador blanco cuyas huellas quedan congeladas |
| Lumbre de las Ruinas | Fuego | Raro | 5-9 | Ataque alto | Habita chimeneas abandonadas y protege brasas antiguas |
| Serpiente del Brezal | Veneno | Raro | 5-10 | Ataque alto, vida baja | Dragón sinuoso oculto entre hierbas violetas |
| Guardián del Alba | Luz | Épico | 7-12 | Defensa alta | Vigila patios al amanecer y desafía a cuidadores dignos |
| Acechante Umbrío | Sombra | Épico | 8-15 | Perfil completo | Solo se distingue por ojos violetas entre corredores oscuros |
| Anciano de Lava | Fuego | Legendario | 12-20 | Vida y ataque altos | Antiguo dragón de piedra volcánica que despierta raramente |

## 10.3 Recompensas salvajes

| Resultado | Dracoins | XP |
|---|---:|---:|
| Derrota | 3 DC | 4 XP |
| Empate | 6 DC | 6 XP |
| Victoria común/rara | 10 DC | 10 XP |
| Victoria épica | 14 DC | 14 XP |
| Victoria legendaria | 20 DC | 20 XP |

---

# 11. Economía inicial

## 11.1 Objetivos económicos

- El jugador obtiene su primer huevo durante la primera sesión.
- Un jugador activo puede comprar un Huevo del Hogar cada 2 o 3 días.
- Un Huevo Elemental representa aproximadamente una semana ligera de juego.
- Un Huevo Arcano representa una meta importante de aproximadamente 2 a 4 semanas,
  según la constancia del jugador.
- La comida diaria consume una parte pequeña de los ingresos.
- Los espacios adicionales son decisiones importantes, no compras impulsivas.

## 11.2 Ingreso esperado

| Fuente | Ingreso esperado |
|---|---:|
| Primera sesión especial | 400-500 DC |
| Tres misiones diarias | 45-90 DC |
| Cinco duelos con recompensa | 20-75 DC |
| Promedio diario habitual | 90-145 DC |
| Dos misiones semanales | 160-360 DC por semana |

Los primeros cinco duelos del día entregan recompensa completa. Los siguientes pueden
entregar experiencia reducida, pero no Dracoins, para evitar farming.

## 11.3 Recompensas de duelo contra jugador

| Resultado | Dracoins | XP | Ranking |
|---|---:|---:|---|
| Derrota | 4 DC | 5 XP | 0 |
| Empate | 8 DC | 8 XP | 40 % del valor del rival |
| Victoria | 15 DC | 12 XP | Valor completo del rival |

## 11.4 Costos de espacios

El jugador inicia con un espacio gratuito. Costos recomendados:

| Capacidad resultante | Costo |
|---:|---:|
| 2 espacios | 250 DC |
| 3 espacios | 500 DC |
| 4 espacios | 800 DC |
| 5 espacios | 1.200 DC |
| 6 espacios | 1.700 DC |
| 7 espacios | 2.300 DC |
| 8 espacios | 3.000 DC |
| 9 espacios | 3.800 DC |
| 10 espacios | 4.700 DC |

## 11.5 Sumideros principales

| Sumidero | Frecuencia |
|---|---|
| Comida básica | Frecuente y barata |
| Comida especial | Ocasional |
| Huevos | Objetivo principal |
| Espacios | Objetivo de largo plazo |

No se recomienda cobrar Dracoins por crecimiento, selección de acompañante, regalo de
huevos ni entrada a combates durante el MVP.

## 11.6 Revisión económica y correcciones

### Problemas detectados

| Área | Problema anterior | Corrección |
|---|---|---|
| Huevo Arcano | `1.500 DC` podía alcanzarse en aproximadamente 7-11 días | Subir a `3.000 DC` y 24 horas de incubación |
| Míticos | Las probabilidades permitían demasiados nacimientos con huevos comprables | Reducirlos drásticamente y concentrarlos en Constelaciones limitadas |
| Slytherin | Un +5 % global de Dracoins podía generar inflación y dominar elecciones | Limitarlo a duelos recompensados y máximo +5 DC diarios |
| Caricias | Podrían convertirse en una fuente gratuita de progreso repetible | Cooldown global de 4 horas, sin Dracoins y XP pequeña aleatoria |
| Combates | Recompensas ilimitadas permitirían farming | Mantener Dracoins completos solo en los primeros 5 duelos diarios |

### Evaluación de costos y recompensas

| Sistema | Evaluación | Decisión de lanzamiento |
|---|---|---|
| Huevos Hogar, Elemental y Emblema | Escalera clara entre entrada, elección y prestigio | Mantener costos |
| Huevo Arcano | Demasiado accesible para su calidad | Subir a 3.000 DC |
| Huevo Constelación | Su poder proviene de escasez, no precio | Mantener fuera de venta |
| Comida básica | Barata y adecuada para evitar que cuidar sea un castigo | Mantener costos |
| Comida especial | Útil como recuperación y pequeño sumidero | Mantener costos |
| Espacios | Progresión larga, pero alcanzable | Mantener costos |
| Misiones diarias | Buen ingreso para sesiones cortas | Mantener recompensas |
| Misiones semanales | Aportan constancia sin dominar la economía | Mantener recompensas |
| Duelos | Sostenibles gracias al límite diario | Mantener recompensas |

### Ritmo económico corregido

Un jugador activo obtiene aproximadamente:

- `90-145 DC` en un día habitual mediante misiones y duelos.
- Un promedio adicional de `25-50 DC diarios` al distribuir recompensas semanales.
- Entre `115 y 195 DC diarios efectivos`, según victorias y constancia.

Con este ritmo:

| Objetivo | Tiempo aproximado |
|---|---:|
| Huevo del Hogar | 2-3 días |
| Segundo espacio | 2-3 días |
| Huevo Elemental | 4-7 días |
| Huevo del Emblema | 5-9 días |
| Huevo Arcano | 16-27 días |
| Espacios de capacidad alta | Varias semanas por espacio |

La economía sigue siendo generosa durante las primeras sesiones, pero conserva metas
de mediano plazo. El principal riesgo de inflación continúa siendo aumentar
recompensas de misiones o eliminar el límite de duelos, no el costo de alimentación.

---

# 12. Hoja de balance inicial

## 12.1 Valores globales de lanzamiento

| Categoría | Valor recomendado |
|---|---|
| Duración objetivo de sesión | 5-15 minutos |
| Dracoins iniciales por vinculación | 400 DC |
| Espacios iniciales | 1 |
| Capacidad máxima | 10 |
| Duelos diarios con Dracoins | 5 |
| Nivel máximo | 20 |
| Mejora por nivel sobre estadísticas base | +2 % |
| Bonificación máxima de casa | +5 % en su fuente específica |
| Tope Slytherin | +5 DC diarios |
| Cooldown de caricia | 4 horas por jugador |
| Beneficio de caricia | +6 Felicidad; 15 % de +3 XP |
| Ventaja elemental | +15 % daño |
| Desventaja elemental | -15 % daño |
| Modificador máximo de temperamento | ±5 % |
| Hambre/Felicidad/Vida máxima | 100 |
| Estado con Vida 0 | Huye, nunca muere |

## 12.2 Rarezas

| Rareza | Probabilidad global | Bono ranking rival |
|---|---:|---:|
| Común | Aproximadamente 60 % | 0 |
| Raro | Aproximadamente 25 % | +2 |
| Épico | Aproximadamente 10 % | +3 |
| Legendario | Aproximadamente 5 % | +4 |
| Mítico | Menor a 0,1 % de todos los nacimientos | +5 |

## 12.3 Huevos

| Huevo | Costo | Incubación | Uso |
|---|---:|---:|---|
| Hogar | 300 DC | 30 min | Entrada |
| Elemental | 650 DC | 2 h | Buscar elemento |
| Emblema | 900 DC | 4 h | Buscar identidad de casa |
| Arcano | 3.000 DC | 24 h | Meta importante; buscar épicos y legendarios |
| Constelación | Recompensa limitada | 24 h | Fuente principal de míticos |

### 12.3.1 Probabilidades finales por huevo

| Huevo | Común | Raro | Épico | Legendario | Mítico |
|---|---:|---:|---:|---:|---:|
| Hogar | 75 % | 20 % | 4,5 % | 0,5 % | 0 % |
| Elemental | 40 % | 40 % | 16 % | 3,999 % | 0,001 % |
| Emblema | 15 % | 45 % | 32 % | 7,99 % | 0,01 % |
| Arcano | 2 % | 25 % | 45 % | 27,9 % | 0,1 % |
| Constelación | 0 % | 5 % | 30 % | 62 % | 3 % |

### 12.3.2 Bonificaciones finales de casas

| Casa | Bonificación |
|---|---|
| Gryffindor | +5 % XP de combates |
| Hufflepuff | +5 % Felicidad obtenida |
| Ravenclaw | +5 % XP de misiones |
| Slytherin | +5 % Dracoins de los primeros 5 duelos, máximo +5 DC diarios |

## 12.4 Necesidades

| Regla | Valor |
|---|---:|
| Estado inicial | Hambre 80, Felicidad 80, Vida 100 |
| Pérdida de Hambre | 1 cada 2 horas |
| Hambre baja | Menor a 30 |
| Pérdida de Felicidad | 1 cada 4 horas mientras Hambre sea baja |
| Felicidad crítica | Menor a 20 |
| Pérdida de Vida | 1 cada 6 horas mientras Felicidad sea crítica |

## 12.5 Crecimiento

| Evolución | Tiempo | XP | Vida | Felicidad |
|---|---:|---:|---:|---:|
| Bebé → Joven | 24 h | 80 | 50 | 30 |
| Joven → Adulto | 72 h adicionales | 250 total | 60 | 40 |

## 12.6 Combate y ranking

| Regla | Valor |
|---|---|
| Daño base | Máximo de 1 entre Ataque - Defensa rival / 2, más variación pequeña |
| Variación de daño | Entre -2 y +2 |
| Rondas máximas por duelo | 10 |
| Puntos base del rival | 5 |
| Modificador por nivel rival | Entre -2 y +3 |
| Victoria | Valor completo del rival |
| Empate | 40 % del valor, redondeado hacia arriba |
| Derrota | 0 puntos |
| Dragón salvaje | 0 puntos de ranking |

## 12.7 Economía resumida

| Concepto | Valor |
|---|---:|
| Ingreso diario habitual | 90-145 DC |
| Ingreso diario efectivo con semanales | 115-195 DC |
| Comida básica | 8-18 DC |
| Comida especial | 35-90 DC |
| Victoria contra jugador | 15 DC, 12 XP |
| Victoria salvaje común/rara | 10 DC, 10 XP |
| Misión diaria | 15-35 DC |
| Misión semanal | 80-180 DC |
| Primer espacio adicional | 250 DC |
| Último espacio adicional | 4.700 DC |
| Huevo Arcano | 3.000 DC |

## 12.8 Contenido de lanzamiento recomendado

| Tipo | Cantidad |
|---|---:|
| Especies coleccionables | 10 |
| Dragones representativos de casas | 4 |
| Elementos | 8 |
| Temperamentos | 5 |
| Tipos de huevo | 5 |
| Alimentos | 8 |
| Dragones salvajes | 10 |
| Misiones diarias posibles | 7 |
| Misiones semanales | 6 |
| Misiones especiales | 9 |

---

# 13. Recomendaciones de validación

Antes del lanzamiento, probar con miembros reales de la comunidad:

1. Si el primer huevo genera emoción suficiente.
2. Si el jugador entiende Hambre, Felicidad y Vida sin explicación extensa.
3. Si alimentar se siente afectuoso y no como una obligación.
4. Si un duelo dura lo suficiente para emocionar, pero menos de dos minutos.
5. Si las diferencias elementales son visibles.
6. Si los dragones de casa resultan deseables.
7. Si ahorrar para huevos y espacios se siente alcanzable.
8. Si los jugadores recuerdan el nombre y temperamento de su dragón.
9. Si los bonos de casa se sienten valiosos sin condicionar la elección.
10. Si las caricias motivan una segunda visita sin sentirse obligatorias.
11. Si la comunidad percibe un nacimiento mítico como un acontecimiento.

El primer ajuste debe priorizar diversión y claridad. La economía y las probabilidades
pueden cambiar; el vínculo emocional con el dragón es la parte que debe funcionar
desde el primer día.

---

# 14. Reporte final de cambios

## 14.1 Cambios realizados

| Cambio | Antes | Nuevo balance | Motivo |
|---|---|---|---|
| Rareza Mítica global | Objetivo aproximado de 1 % | Menor a 0,1 % de nacimientos | Convertir cada mítico en acontecimiento comunitario |
| Mítico en Huevo del Hogar | 0 % | 0 % | Mantener huevos comunes sin míticos |
| Mítico en Elemental | 0,2 % | 0,001 % | Volverlo prácticamente imposible |
| Mítico en Emblema | 0,5 % | 0,01 % | Conservar una posibilidad testimonial |
| Mítico en Arcano | 2 % | 0,1 % | Evitar que el ahorro normal produzca míticos frecuentes |
| Mítico en Constelación | 10 % | 3 % | Mantenerlo como fuente principal, pero extraordinaria |
| Precio Huevo Arcano | 1.500 DC | 3.000 DC | Convertirlo en meta de 2-4 semanas |
| Incubación Huevo Arcano | 8 horas | 24 horas | Reforzar su carácter especial |
| Incubación Constelación | 12 horas | 24 horas | Dar peso ceremonial a la recompensa |
| Bonos de casa | No definidos | Cuatro bonos de +5 % limitados | Dar identidad permanente sin poder directo |
| Caricias | No existían | Gratis cada 4 h, +6 Felicidad, 15 % de +3 XP | Incentivar visitas afectivas sin inflación |
| Revisión económica | Arcano demasiado accesible | Ritmo corregido y límites conservados | Mantener metas de mediano plazo |

## 14.2 Por qué se hicieron

### Proteger el prestigio Mítico

Con una comunidad pequeña, incluso pocos míticos por semana harían que dejaran de
sentirse especiales rápidamente. Las nuevas probabilidades trasladan la emoción desde
la compra repetitiva hacia hitos y eventos de Constelación.

### Dar valor al Huevo Arcano

El Arcano anterior podía comprarse demasiado pronto y ofrecía demasiada probabilidad
Mítica. Ahora es una meta visible de mediano plazo centrada en épicos y legendarios.

### Reforzar identidad sin crear una casa dominante

Los bonos de casa recompensan estilos distintos. Se evitó cualquier bono a daño,
ranking o probabilidades. Slytherin recibe un tope explícito porque los Dracoins tienen
impacto acumulativo sobre toda la economía.

### Incentivar afecto, no obligación

Las caricias crean un motivo amable para volver varias veces al día. Su recompensa
principal es emocional y de felicidad; la experiencia es pequeña, aleatoria y no
entrega moneda.

## 14.3 Nuevo balance recomendado para lanzamiento

| Área | Recomendación final |
|---|---|
| Ingreso diario habitual | 90-145 DC |
| Ingreso diario efectivo con semanales | 115-195 DC |
| Huevo Hogar | 300 DC, 30 minutos, 0 % Mítico |
| Huevo Elemental | 650 DC, 2 horas, 0,001 % Mítico |
| Huevo Emblema | 900 DC, 4 horas, 0,01 % Mítico |
| Huevo Arcano | 3.000 DC, 24 horas, 0,1 % Mítico |
| Huevo Constelación | Recompensa limitada, 24 horas, 3 % Mítico |
| Entrega comunitaria de Constelaciones | Máximo orientativo de 5 por mes |
| Primer espacio adicional | 250 DC |
| Último espacio adicional | 4.700 DC |
| Comida básica | 8-18 DC |
| Comida especial | 35-90 DC |
| Duelos recompensados | Primeros 5 del día |
| Caricia | Gratis cada 4 horas, +6 Felicidad, 15 % de +3 XP |
| Bono de casa | +5 % en fuente específica; Slytherin máximo +5 DC diarios |

Este balance debe lanzarse como punto de partida y revisarse después de observar al
menos dos semanas de comportamiento real de la comunidad.
