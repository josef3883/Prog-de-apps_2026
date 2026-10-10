# Validación de implementación — 001-reparto-cuenta

Fecha: 2026-10-09 (America/Guayaquil). Implementación React/Vite, JavaScript y useState.
No se modificaron spec.md ni la constitución. Las 35 tareas se completan con los checks
registrados aquí; no se afirma haber evaluado personalmente la comprensión del estudiante.

## Evidencia ejecutada

- Node 24.20.0, Vite 8.3.4, Vitest 5.0.3 y jsdom 30.1.2.
- npm.cmd run test:run: 12 archivos y 136 pruebas aprobadas.
- npm.cmd run lint: sin errores ni advertencias.
- npm.cmd run build: bundle generado correctamente; no recursos de terceros en la ruta funcional.
- Pruebas escritas antes de los módulos: siete suites inicialmente fallaron por módulos
  ausentes; después pasaron 41 pruebas de US1. La suite de errores de pantalla falló
  antes de incorporar mensajes; después pasaron 124 pruebas. Offline, arquitectura,
  composición y extensión completaron las 136 pruebas finales.
- Spec SHA256 original/final:
  2E7E20D862FFA432CD36479C5042803673903125FC6DE56B3D3709C09DBC3220.
- Revisión de cambios: sin secretos ni claves de API añadidos. .env*, dependencias,
  builds, informes temporales y herramientas QA quedan ignorados.
- No existe .specify/extensions.yml; no hay hooks pendientes ni checklists de feature.

## Navegador real, offline y tiempo

Chrome headless 154.0.8037.98, Windows, viewport 1280×960; segunda comprobación a 375×812.
Se ejecutó scripts/validar-navegador.mjs contra el build servido por preview en loopback.
El conector de navegador no tenía superficies disponibles; se utilizó Playwright como
herramienta temporal aislada en .qa-tools, sin cambiar las dependencias de la aplicación.
Las capturas de escritorio/móvil fueron inspeccionadas visualmente; no hubo desbordamiento.

El cronómetro usa performance.now desde el clic real en el botón hasta dos frames de
renderizado; después comprueba el texto visible. No es un benchmark de la función de
cálculo ni una medición humana manual. La suite UI también exige salida en menos de 1000 ms.

| Escenario | Resultado observado | Cronómetro navegador |
|---|---|---:|
| US1.1: 100.00 / 4, 10 %, exacto | 27.50 por persona | 24.9 ms |
| US1.2: 90.00 / 3, 0 %, exacto | 30.00 por persona | 19.3 ms |
| US1.3: 10.00 / 3, 0 %, exacto | 3.33 por persona | 23.1 ms |
| US1.4: 10.00 / 3, 0 %, hacia arriba | 4.00 por persona | 29.2 ms |
| US2.1: cero personas | Debe haber al menos una persona; sin resultado | 23.9 ms |
| US2.2: monto abc | Monto inválido; sin resultado | 19.2 ms |
| US3.1: conexión desactivada después de cargar | Exacto 3.33 y hacia arriba 4.00 por persona | Correcto en ambos modos |

Se desactivó realmente la conectividad del contexto Chrome mediante setOffline(true),
no solamente navigator.onLine. Se observaron cero solicitudes después de desactivarla,
cero escrituras de almacenamiento, localStorage/sessionStorage vacíos, ninguna cookie
y cero errores de página. Se bloquearon escrituras de Storage, IndexedDB y cookies.
La prueba Vitest bloquea además fetch, XMLHttpRequest y WebSocket.

Límite: la aplicación debe estar cargada o servida localmente sin depender de Internet.
No se garantiza primera apertura/recarga de una URL remota desconectada. No se ha añadido PWA.
Los tiempos reflejan este equipo/navegador headless, no todos los dispositivos posibles.

## Hallazgos del análisis y resolución

| Hallazgo | Tratamiento |
|---|---|
| I1: seis frente a siete escenarios | Se prueban los siete. Se conserva la discrepancia documental de SC-001 sin editar spec.md. |
| I2: personas negativas fraccionarias | Prioridad de FR-009: -0.5/-0,5 muestran Debe haber al menos una persona; tests de dominio, UI y Chrome. El cronómetro adicional de Chrome registró 18.5 ms. Research/modelo actualizados para coincidir, spec intacta. |
| A1: precondición offline | Validación y README explicitan recursos previamente cargados y límite de recarga remota. No se afirma disponibilidad que no se probó. |
| G1: tiempo | Aserción <1000 ms en Vitest y cronómetro en Chrome con frames de renderizado. |
| U1: composición | Tests negativos para aplicar ausente, id/etiqueta vacíos, orden inválido, duplicados y falta de modo inicial. Se aclara que build por sí solo no ejecuta validación de composición. |
| D1: FR-007 y FR-009 duplicados | Ambos conservados y cubiertos con el mismo comportamiento de cero personas. |

## Explicación de funciones productivas

Los contratos JSDoc están junto al código. Las siguientes explicaciones permiten al
estudiante describir propósito, entradas, salida y errores usando ejemplos ejecutables.
Los callbacks simples se explican por su función en la operación que los contiene.

| Función / ubicación | Qué hace y por qué existe | Recibe / devuelve | Errores y ejemplo verificable |
|---|---|---|---|
| aCentesimas — domain/validarEntrada.js | Normaliza decimales sin perder precisión; comparte conversión de monto/propina. | Texto léxicamente válido / bigint en centésimas. | Sin error con precondición; BigInt puede fallar con texto fuera de contrato. 10,25 -> 1025n. |
| validarEntrada — domain/validarEntrada.js | Valida antes del cálculo y produce Cuenta inmutable. | Tres strings / unión ok-cuenta o error-campo-mensaje. | Errores de usuario retornados, no lanzados; tipos no string incumplen contrato. abc -> Monto inválido. |
| calcularDivision — domain/calcularDivision.js | Redondea propina, suma, divide y delega política final; solo cálculo. | Cuenta válida y estrategia / Resultado inmutable. | Propaga error de dependencia; no valida. 0.05 con 10 % -> 0.06. |
| aplicar — data/redondeoExacto.js | Redondea al centavo, mitad arriba. | Racional válido de centavos / bigint. | Sin errores dentro de contrato; divisor cero/tipos incorrectos son error de programación. 201n/2n -> 101n. |
| aplicar — data/redondeoHaciaArriba.js | Redondea al entero monetario mayor o igual. | Racional válido / bigint múltiplo de 100. | Igual precondición; 1000n/3n -> 400n y 3000n/1n -> 3000n. |
| formatearMoneda — presentation/formateadorMoneda.js | Presenta sin elegir política ni moneda. | Centavos bigint >=0 / string de dos decimales. | Sin errores dentro de contrato; tipo inválido es error de programación. 1n -> 0.01. |
| useDivisor — presentation/useDivisor.js | Coordina estado local e inyección, separando eventos y negocio. | Dependencias compuestas / estado y acciones. | Propaga fallos de programación; campos inválidos se vuelven error de estado. Test con dobles confirma cálculo solo por evento. |
| cambiarCampo — dentro del hook | Cambia un campo y limpia salida/error sin calcular. | Nombre de campo válido y string / void. | Nombre/tipo fuera del contrato es error del llamador. El callback de setEntradas conserva los demás campos. |
| cambiarModo — dentro del hook | Selecciona una opción existente y limpia salida/error. | id del catálogo / void. | Un id ajeno viola la precondición de UI; no crea estrategias. Test de extensión usa un id adicional. |
| calcular — dentro del hook | Valida; si es válido, encuentra la estrategia, calcula y formatea. | Estado del hook / void; publica salida o error. | Rechazo esperado no lanza; fallos de dependencias sí se propagan. El callback find compara ids, no tipos. |
| PantallaDivisor — presentation/PantallaDivisor.jsx | Muestra campos, modos, errores y resultado de una pantalla. | Dependencias / JSX. | No inventa validaciones. onSubmit cancela navegación y llama al hook; onChange pasa texto/id; map genera opciones. A1–A6 prueban esos callbacks. |
| crearDependencias — main.jsx | Descubre contratos y compone objetos concretos solo aquí. | Módulos exportados o glob por defecto / dependencias inmutables. | Lanza por metadatos/contratos inválidos, ids duplicados o falta de exacto. map valida/crea cada objeto y sort ordena por orden/id. Tests negativos explícitos. |
| montarAplicacion — main.jsx | Monta la pantalla con StrictMode y dependencias compuestas. | HTMLElement existente / raíz React. | Propaga errores de composición o contenedor inválido. Comprobado mediante build montado en Chrome. |

cuenta.js, resultado.js y estrategiaRedondeo.js contienen tipos JSDoc, no funciones ni
instancias de servicios. El único punto productivo que crea objetos { aplicar } es main.
Las estrategias adicionales se descubren eager sin editar consumidores. Los registros
numéricos Cuenta/Resultado son valores, no implementaciones de servicios.

## Funciones auxiliares de verificación

- montar (soporte.jsx): recibe JSX, crea contenedor/raíz de prueba y devuelve contenedor;
  existe para ejercitar UI real de React en jsdom y propaga errores de render.
- cambiar: recibe contenedor, nombre y texto; usa setter nativo y evento, devuelve Promise<void>;
  falla si el control de prueba no existe. Evita manipular el estado React directamente.
- completar: recibe contenedor y valores; llama cambiar para cada campo/modo; propaga fallos.
- calcular (soporte.jsx): recibe contenedor; dispara submit y espera act; devuelve Promise<void>.
  Falla si falta formulario; no implementa negocio.
- afterEach: desmonta, elimina contenedores y restaura dobles/globales para aislar suites.
- Prueba (suite hook): monta un componente mínimo y observa el estado mediante useEffect,
  sin mutar variables externas durante render. Permite comprobar el hook por inyección.
- archivos (suite arquitectura): recorre src y devuelve rutas JS/JSX para inspeccionar
  dependencias; propaga errores de filesystem. Los callbacks de las suites son casos con
  entradas/salidas explícitas; las aserciones fallidas constituyen su salida de error.
- scripts/validar-navegador.mjs: recorrido de pruebas Chrome; recibe como precondiciones
  Chrome, Playwright temporal y preview en puerto 4173, genera JSON/capturas y termina
  con error si una salida, tiempo, solicitud, almacenamiento o layout incumple lo esperado.
  Sus callbacks evaluate miden frames, observan escrituras o inspeccionan el DOM; no son
  código de la aplicación. finally cierra el navegador incluso ante fallos.

## Reproducibilidad

README.md y quickstart.md documentan scripts y la validación real. El harness Chrome se
conserva en scripts/validar-navegador.mjs; los resultados/capturas temporales se escriben
bajo .qa-tools, ignorado. No se instala Playwright en package.json ni se necesita para
las 136 pruebas Vitest. Las pruebas de extensión inyectan un modo doble, sin incorporar
una tercera política productiva.
