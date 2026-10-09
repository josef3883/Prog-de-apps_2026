---
description: "Tareas de implementación del reparto de cuenta en React"
---

# Tasks: Reparto de cuenta

**Input**: documentos de `specs/001-reparto-cuenta/`.
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md),
[data-model.md](data-model.md), [contratos](contracts/modulos.md),
[aceptación](contracts/interfaz.md) y [quickstart.md](quickstart.md).
**Constitución**: `.specify/memory/constitution.md`.
**Tests**: obligatorios por la spec (SC-002) y la constitución; usar Vitest.
**Organization**: historias por prioridad. Este archivo no implementa ni declara trabajo terminado.

## Format: `[ID] [P?] [Story] Description`

Cada tarea tiene casilla, ID secuencial y rutas concretas. `[P]` indica que puede realizarse
junto a las tareas del mismo grupo una vez satisfechas las dependencias indicadas abajo.
`[US1]`, `[US2]` y `[US3]` identifican las historias de la spec. Sin etiqueta de historia:
preparación, contratos compartidos o verificaciones transversales.

## Path Conventions

Rutas relativas a la raíz de divisor_cuenta_web: `src/`, `tests/` y `specs/001-reparto-cuenta/`.
Mantener React/Vite, JavaScript ESM y JSX; no añadir bibliotecas de estado, backend ni DB.
No modificar `specs/001-reparto-cuenta/spec.md` ni la constitución para acomodar la implementación.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: preparar el proyecto existente y el entorno de tests; no reinicializar Vite.

- [ ] T001 Instalar Vitest y jsdom como dependencias de desarrollo compatibles con Node/Vite existentes en `package.json` y `package-lock.json`; añadir scripts test=vitest y test:run=vitest run, conservando dev/build/lint/preview y sin añadir librerías de estado.
- [ ] T002 Configurar Vitest en `vite.config.js`, conservando el plugin React: Node por defecto, descubrimiento de tests JS/JSX y entorno jsdom seleccionado en las suites de presentación; comprobar que build sigue funcionando.
- [ ] T003 Crear soporte común de montaje/desmontaje con createRoot y act, eventos de inputs controlados y limpieza de espías en `tests/presentation/soporte.jsx`; preparar el entorno act y evitar dependencias adicionales de utilidades de UI.

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: fijar contratos de datos antes de cualquier historia. Sin lógica de UI ni data.

- [ ] T004 [P] Definir con JSDoc Cuenta en `src/domain/cuenta.js`: montoCentavos bigint «>= 0», personas bigint «>= 1», propinaCentesimas bigint «Entre 0 y 10000 inclusive.»; registro inmutable, sin modo concreto, validación, formato, React ni DOM.
- [ ] T005 [P] Definir con JSDoc Resultado en `src/domain/resultado.js`: importeCentavos bigint «importeCentavos >= 0»; dato numérico sin símbolo ni texto de UI, sin cálculo ni validación.
- [ ] T006 [P] Documentar en `src/domain/estrategiaRedondeo.js` el contrato mínimo aplicar(valor): racional { numerador, denominador } de centavos bigint, «numerador >= 0 y denominador > 0», salida bigint >=0; pureza, determinismo, sincronía y precondiciones; no instanciar una implementación ni imponer TypeScript.

**Checkpoint**: contratos compartidos definidos; a partir de aquí se implementan historias.

## Phase 3: User Story 1 - Calcular el reparto (Priority: P1) — MVP

**Goal**: ingresar datos válidos, elegir política y obtener importe individual con dos decimales.
**Independent Test**: calcular los cuatro casos US1: 27.50, 30.00, 3.33 y 4.00 por persona.
No se requiere conexión ni almacenamiento para esta ruta; la comprobación offline es US3.

### Tests for User Story 1

Escribir las pruebas antes del módulo correspondiente y comprobar que detectan su ausencia
o comportamiento incompleto; no se introduce una aprobación del usuario ni un principio TDD.

- [ ] T007 [P] [US1] Crear pruebas de normalización válida en `tests/domain/validarEntrada.test.js`: punto/coma, una/dos cifras, espacios exteriores, monto cero, personas >=1, propina 0/100 y valores superiores a Number.MAX_SAFE_INTEGER; verificar conversión exacta a bigint y unión { ok: true, cuenta } (FR-011, Assumptions).
- [ ] T008 [P] [US1] Crear pruebas en `tests/domain/calcularDivision.test.js` con estrategia doble: propina antes del reparto, empate de propina 0.05 al 10 % da total 0.06, racional sin pérdida y una llamada a aplicar; comprobar que el cálculo no valida ni formatea ni reconoce tipos concretos (FR-004, Assumptions).
- [ ] T009 [P] [US1] Crear en `tests/data/redondeos.test.js` los casos de cada política y en `tests/contracts/estrategiaRedondeo.test.js` la batería común: cero, enteros, bigint, no negatividad, determinismo y ausencia de mutación; verificar 1000n/3n -> 333n o 400n y empate 201n/2n -> 101n en exacto (FR-005/006, LSP).
- [ ] T010 [P] [US1] Crear pruebas de `formatearMoneda` en `tests/presentation/formateadorMoneda.test.js`: cero, centavos con cero inicial, enteros y cantidades grandes; exigir punto, exactamente dos decimales y ausencia de símbolo/agrupación, sin redondear (SC-004).
- [ ] T011 [P] [US1] Crear pruebas jsdom del hook con componente de prueba y dependencias dobles en `tests/presentation/useDivisor.test.jsx`: campos vacíos, «inicialmente exacto», entradas string, resultado/error nullable, cálculo solo al pulsar, selección por id y ocultación de salida al editar campo/modo (FR-003, Edge Cases).
- [ ] T012 [P] [US1] Crear pruebas jsdom de la pantalla en `tests/presentation/PantallaDivisor.test.jsx` para A1–A4 de `specs/001-reparto-cuenta/contracts/interfaz.md`: controles etiquetados, modos del catálogo y salidas 27.50/30.00/3.33/4.00 «por persona»; verificar una pantalla y exactamente dos decimales sin símbolo (FR-001/002, SC-001/004).

### Implementation for User Story 1

- [ ] T013 [US1] Implementar `validarEntrada` en `src/domain/validarEntrada.js` según `specs/001-reparto-cuenta/data-model.md`: monto «No negativo, punto o coma decimal, hasta dos decimales, sin miles.», personas «Entero positivo.», propina «De 0 a 100 inclusive, punto o coma, hasta dos decimales, sin miles.»; recortar espacios, exigir parte entera, rechazar exponentes/agrupación y devolver unión ok/cuenta o error/campo/mensaje en orden monto → personas → propina; normalizar con bigint, sin límites monetarios arbitrarios ni excepciones para errores de usuario.
- [ ] T014 [P] [US1] Implementar función aplicar y metadatos id=exacto, etiqueta=Exacto, orden=0 en `src/data/redondeoExacto.js`: redondeo racional al centavo con mitades hacia arriba, bigint y sin crear objetos de estrategia al importar (FR-005).
- [ ] T015 [P] [US1] Implementar función aplicar y metadatos id=hacia-arriba, etiqueta=Hacia arriba, orden=1 en `src/data/redondeoHaciaArriba.js`: techo al múltiplo de 100 centavos, cero/enteros conservados, bigint y sin crear objetos de estrategia al importar (FR-006, Edge Cases).
- [ ] T016 [US1] Implementar `calcularDivision(cuenta, estrategia)` en `src/domain/calcularDivision.js`: propina=mitad-arriba(montoCentavos*propinaCentesimas/10000), suma y reparto racional; aplicar la estrategia una vez y devolver Resultado; no validar, formatear, importar data ni ocultar fallos de programación.
- [ ] T017 [P] [US1] Implementar `formatearMoneda(importeCentavos)` en `src/presentation/formateadorMoneda.js` mediante unidades/resto bigint y relleno a dos cifras; no redondear ni añadir símbolo, agrupación o «por persona».
- [ ] T018 [US1] Implementar `useDivisor(dependencias)` en `src/presentation/useDivisor.js` con useState y contrato de `specs/001-reparto-cuenta/contracts/modulos.md`: recibir validarEntrada/calcularDivision/formatearMoneda/modos, resolver modo por id, iniciar entradas vacías y salida/error null, calcular solo por evento y ocultar salida al editar; una entrada inválida impide invocar cálculo, sin importar data ni crear estrategias.
- [ ] T019 [US1] Implementar `PantallaDivisor({ dependencias })` en `src/presentation/PantallaDivisor.jsx`: usar el hook, campos textuales controlados, opciones derivadas del catálogo, Calcular y salida «X.XX por persona»; no delegar el rechazo a type=number ni a restricciones HTML que impidan mensajes propios; no calcular ni validar dentro del componente.
- [ ] T020 [US1] Adaptar `src/index.css` a los campos, modos, botón y resultado de la única pantalla; retirar estilos de demostración que interfieran sin introducir recursos remotos ni requisitos funcionales adicionales.
- [ ] T021 [US1] Componer en `src/main.jsx` mediante import.meta.glob('./data/redondeo*.js', { eager: true }): verificar contrato/metadatos e ids únicos, ordenar por orden/id, crear allí objetos { aplicar }, catálogo y dependencias e inyectarlos a PantallaDivisor; sustituir App como entrada visual sin crear otro punto de composición.
- [ ] T022 [US1] Ejecutar las suites US1 de `tests/domain/`, `tests/data/`, `tests/contracts/estrategiaRedondeo.test.js` y `tests/presentation/`, y corregir sus fallos en los módulos de esta historia; comprobar A1–A4 en `src/main.jsx` montado y el build antes de aceptar el MVP.

**Checkpoint**: ruta de cálculo válida utilizable y probada. US1 es el alcance MVP; aún no
se declara cumplimiento completo de errores ni validación offline.

## Phase 4: User Story 2 - Recibir errores de entrada (Priority: P2)

**Goal**: mostrar mensajes exactos ante entradas inválidas y no confundirlos con un resultado.
**Independent Test**: cero personas -> «Debe haber al menos una persona»; abc como monto
-> «Monto inválido»; en ambos casos no hay resultado visible.

### Tests for User Story 2

- [ ] T023 [P] [US2] Ampliar `tests/domain/validarEntrada.test.js` con todas las categorías de A5/A6 y SC-002: monto vacío/negativo/no numérico/no finito/miles/>2 decimales; personas cero/negativas/no enteras/no numéricas/vacías/no finitas; propina vacía/no numérica/no finita/miles/>2 decimales/fuera de 0..100; verificar mensajes y prioridad monto → personas → propina, según `specs/001-reparto-cuenta/contracts/interfaz.md`.
- [ ] T024 [P] [US2] Crear pruebas jsdom parametrizadas en `tests/presentation/erroresEntrada.test.jsx` que obtengan primero un resultado válido y después calculen cada categoría inválida de SC-002: exigir mensaje exacto, ausencia de resultado y cero llamadas al cálculo para el rechazo; comprobar recuperación al corregir y volver a Calcular.

### Implementation for User Story 2

- [ ] T025 [US2] Completar en `src/presentation/useDivisor.js` la publicación de error/campo/mensaje de validarEntrada, borrado del resultado al rechazar, limpieza de error al editar y recuperación en cálculo válido; ajustar `src/domain/validarEntrada.js` solo si T023 identifica incumplimientos de su contrato, sin trasladar validación a calcularDivision.
- [ ] T026 [US2] Mostrar en `src/presentation/PantallaDivisor.jsx` el error del hook junto al campo correspondiente y sin resultado simultáneo: «Monto inválido», «Debe haber al menos una persona», «Número de personas inválido» o «Propina inválida»; conservar los datos para corregirlos (FR-007/008/009).
- [ ] T027 [US2] Ejecutar `tests/domain/validarEntrada.test.js`, `tests/presentation/erroresEntrada.test.jsx` y regresión US1; verificar A5/A6 y cobertura de cada categoría de SC-002 contra `specs/001-reparto-cuenta/contracts/interfaz.md`, corrigiendo fallos antes del siguiente checkpoint.

**Checkpoint**: US1 y US2 verificables por separado; los errores no dejan resultados previos.

## Phase 5: User Story 3 - Calcular sin conexión (Priority: P3)

**Goal**: calcular sin red ni almacenamiento externo cuando la pantalla ya está disponible.
**Independent Test**: cargar el build, desactivar conexión, completar una cuenta y obtener
el resultado con ambos modos, sin solicitudes ni escrituras de datos de cuenta.

### Tests for User Story 3

- [ ] T028 [US3] Crear `tests/presentation/sinConexion.test.jsx` para A7: tras montar, bloquear/observar fetch, XMLHttpRequest, WebSocket y escrituras de localStorage/sessionStorage/IndexedDB/cookies; introducir datos, cambiar entre ambos modos y calcular; exigir salida correcta y ninguna solicitud/escritura, sin confundir navigator.onLine con desconexión real.

### Implementation for User Story 3

- [ ] T029 [US3] Revisar `src/main.jsx`, `src/presentation/PantallaDivisor.jsx`, `src/presentation/useDivisor.js`, `src/index.css` e `index.html` para que la ruta productiva use recursos locales empaquetados y estrategias eager; eliminar del flujo cualquier solicitud o persistencia de cuenta encontrada, sin añadir service worker, backend ni almacenamiento.
- [ ] T030 [US3] Ejecutar `tests/presentation/sinConexion.test.jsx` y el build, y realizar la prueba offline real de `specs/001-reparto-cuenta/quickstart.md` sobre preview con recursos ya cargados; registrar navegador, modos, salidas, solicitudes y almacenamiento observados en `specs/001-reparto-cuenta/validacion.md`, dejando explícito el límite de recarga remota offline.

**Checkpoint**: las tres historias cubiertas; A7 incluye automatización y comprobación real.

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: verificar constitución, extensión, comprensión y aceptación completa.

- [ ] T031 [P] Crear y ejecutar `tests/contracts/arquitectura.test.js` sobre el grafo productivo `src/`: dominio sin React/DOM/data/presentation, presentación sin data, data sin presentation, glob/composición concreta solo en `src/main.jsx`; comprobar ausencia de selección por tipos concretos y de importaciones remotas en la ruta funcional, sin convertir fixtures/tooling en capas de producción.
- [ ] T032 [P] Crear y ejecutar `tests/presentation/extensibilidad.test.jsx` con un tercer modo doble inyectado: la pantalla lo ofrece, el hook lo selecciona y el cálculo invoca aplicar sin editar consumidores; complementar T031 comprobando descubrimiento eager no limitado a dos nombres en `src/main.jsx`; no añadir una tercera regla productiva a la spec.
- [ ] T033 Revisar JSDoc y funciones de `src/domain/`, `src/data/`, `src/presentation/` y `src/main.jsx`; documentar qué hacen, por qué existen, qué reciben/devuelven y errores/precondiciones; registrar una explicación por función y caso de prueba en `specs/001-reparto-cuenta/validacion.md` para facilitar la explicación del estudiante, sin afirmar que se verificó su comprensión personal.
- [ ] T034 Ejecutar la guía `specs/001-reparto-cuenta/quickstart.md`, incluyendo medición con cronómetro del resultado visible antes de un segundo (SC-003) y revisión de formato en todas las salidas (SC-004); registrar dispositivo, navegador, mediciones y siete escenarios en `specs/001-reparto-cuenta/validacion.md`; mantener documentada la discrepancia SC-001 sin editar spec.md.
- [ ] T035 Ejecutar npm run test:run, npm run lint y npm run build tras integrar todas las historias, revisar cambios por secretos/API keys y confirmar que `specs/001-reparto-cuenta/spec.md` sigue intacta; registrar resultados reales y limitaciones en `specs/001-reparto-cuenta/validacion.md`, y actualizar `README.md` con ejecución y límites offline verificados.

## Dependencies & Execution Order

### Phase Dependencies

```text
T001 → T002 → T003
               ↓
        T004 / T005 / T006
               ↓
        US1 (T007–T022)
               ↓
        US2 (T023–T027)
               ↓
        US3 (T028–T030)
               ↓
        cierre (T031–T035)
```

Cada historia tiene su propio criterio de prueba, pero comparte hook/pantalla con las
anteriores. No se implementan las tres a la vez: produciría conflictos en los mismos
archivos y ocultaría dependencias. Es posible preparar suites independientes tras Fase 2;
la integración y los checkpoints siguen la prioridad US1 → US2 → US3.

### Within Each User Story

- US1: T007–T012 pueden escribirse en paralelo tras T003–T006. T013 depende de T007;
  T014/T015 de T009; T016 de T008; T017 de T010. Tras esas implementaciones, T018 depende
  de T011 y de los contratos de funciones; T019 de T012/T018; T020 después de T019;
  T021 integra T013–T019 y T022 verifica todo el incremento.
- US2: T023/T024 se escriben después de US1 y no comparten archivos; T025 depende de
  ambos tests; T026 de T025; T027 integra y verifica.
- US3: T028 antes de T029; T030 después de ambos. Sus comprobaciones reales requieren build.
- Cierre: T031/T032 pueden hacerse juntos tras US3; T033–T035 se realizan en orden porque
  comparten validacion.md. Corregir y repetir solamente checks afectados por cambios.

### Parallel Opportunities

[P] indica oportunidad de trabajo, no autorización para lanzar agentes ni saltar dependencias.
T004/T005/T006 son independientes. Las seis tareas de pruebas US1 tienen archivos distintos.
T014/T015/T017 pueden implementarse juntas después de sus tests. T023/T024 son suites
independientes. T031/T032 verifican preocupaciones diferentes en archivos distintos.

## Parallel Example: User Story 1

Tras Fase 2, escribir simultáneamente T008 (cálculo con doble), T009 (redondeos/contrato)
y T010 (formato). Después de sus pruebas, implementar T014, T015 y T017 en archivos
distintos. Esperar su integración antes de T018–T022.

## Parallel Example: User Story 2

Tras T022, escribir T023 en tests/domain/validarEntrada.test.js y T024 en
tests/presentation/erroresEntrada.test.jsx en paralelo. T025/T026 se hacen secuencialmente;
no editar useDivisor o PantallaDivisor desde dos tareas simultáneas.

## Parallel Example: User Story 3

US3 no tiene tareas de implementación paralelas independientes. Mientras se escribe T028,
puede prepararse el procedimiento de navegador de quickstart.md, sin editar los mismos
archivos ni declarar finalizada T030 antes de T029. La automatización y la prueba real
se integran en orden, sin inventar paralelismo entre tareas dependientes.

## Implementation Strategy

### MVP First (User Story 1 Only)

Completar preparación, contratos compartidos y T007–T022. Demostrar los cuatro cálculos
válidos con ambos modos. Este MVP permite revisar la ruta principal; no presentar el
feature completo hasta terminar US2, US3 y cierre. No se incluye despliegue automático.

### Incremental Delivery

Añadir mensajes y rechazos con US2 conservando los tests US1. Después verificar ausencia
de red/persistencia con US3. Cerrar con constitución, extensión, explicación pedagógica,
tiempo visible y todos los checks. Marcar casillas únicamente cuando la tarea se ejecute
y se verifique; este documento deja las 35 tareas pendientes.

## Notes

- Cobertura: A1–A4 → T012/T022; A5/A6 → T023/T024/T027; A7 → T028/T030.
- FR-001/002 → T019/T021; FR-003 → T011/T018; FR-004 → T008/T016;
  FR-005/006 → T009/T014/T015; FR-007/008/009 → T013/T023–T027;
  FR-010 → T028–T030; FR-011 → T007/T013.
- SC-001 → siete escenarios, T022/T027/T030/T034; SC-002 → T023/T024/T027;
  SC-003 → T034; SC-004 → T010/T012/T017/T034.
- Los módulos de producción de dominio/data/presentación son exactamente los del plan;
  soporte.jsx y tests nuevos son infraestructura de pruebas, no capas adicionales.
- Objetos concretos productivos solo en main; pruebas usan funciones exportadas y dobles.
- No introducir límites monetarios, políticas de redondeo nuevas ni reglas constitucionales.
- No existen hooks before_tasks/after_tasks: .specify/extensions.yml no está presente.
