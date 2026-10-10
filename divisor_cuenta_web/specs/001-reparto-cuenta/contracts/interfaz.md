# Contrato de interfaz y aceptación

Una pantalla contiene monto, personas, propina, opciones de redondeo y Calcular.
Los campos se conservan como texto para admitir coma decimal; los inputs no delegan la
validación a type=number ni a restricciones HTML que impidan mostrar el mensaje exigido.
Las opciones iniciales son Exacto y Hacia arriba. La salida válida es «X.XX por persona»,
sin símbolo monetario. El error no comparte pantalla con un resultado válido anterior.
El botón desencadena validación/cálculo; editar no calcula automáticamente.

## Escenarios ejecutables con Vitest

Montar PantallaDivisor con createRoot en jsdom; envolver eventos y actualización en act.
Usar controles con etiquetas y eventos nativos, desmontar tras cada caso. La integración
usa funciones aplicar y dependencias inyectadas; los objetos concretos de producción
siguen componiéndose únicamente en main. Si se necesita sustituir una estrategia, usar
un doble con contrato aplicar, sin reconocer su tipo desde el consumidor.

| Caso | Entrada/acción | Salida esperada | Referencia |
|---|---|---|---|
| A1 | 100.00, 4, 10, exacto; Calcular | 27.50 por persona | US1.1, FR-004/005 |
| A2 | 90.00, 3, 0, exacto; Calcular | 30.00 por persona | US1.2 |
| A3 | 10.00, 3, 0, exacto; Calcular | 3.33 por persona | US1.3 |
| A4 | 10.00, 3, 0, hacia arriba; Calcular | 4.00 por persona | US1.4, FR-006 |
| A5 | 50.00, 0, propina válida; Calcular | Debe haber al menos una persona; sin resultado | US2.1, FR-007 |
| A6 | abc, personas/propina válidas; Calcular | Monto inválido; sin resultado | US2.2, FR-008 |
| A7 | Tras cargar, bloquear red y almacenamiento; introducir cuenta válida y calcular | Resultado correcto, cero solicitudes y escrituras | US3.1, FR-010 |

A7 automatiza en jsdom espías que fallen ante fetch, XMLHttpRequest y escrituras en
almacenamiento; se complementa con navegador realmente offline. No basta modificar
navigator.onLine para afirmar que se probó desconexión real.
SC-001 dice 6/6, pero esta tabla cubre los siete escenarios existentes sin editar la spec.

## Cobertura adicional de requisitos y criterios

| Referencias | Pruebas previstas |
|---|---|
| FR-001/002 | Una pantalla, tres entradas y opciones del catálogo. |
| FR-003, Edge Cases | Editar campos/modo no llama al cálculo; Calcular sí; resultado anterior se oculta al editar. |
| FR-005/006 | Empate final: 2.01 entre 2 exacto da 1.01; entero 30.00 hacia arriba permanece 30.00; cero permanece 0.00. |
| Assumptions | 0.05 con 10 % y una persona da 0.06: propina 0.005 se redondea primero a 0.01. |
| FR-008, SC-002 | Monto vacío, negativo, abc, Infinity/NaN, 1,000, 1.000, 1,234.56, 1.234,56 y 1.001: Monto inválido, sin resultado previo. |
| FR-009, SC-002 | Personas 0/-1: mensaje de al menos una; 1.5/abc/vacío/Infinity: Número de personas inválido, sin resultado. |
| FR-009, SC-002 | Propina abc/Infinity/vacía/-1/100.01/1,000/1.000/1,234.56/1.234,56/0.001: Propina inválida, sin resultado previo. |
| FR-011 | Aceptar punto/coma y una/dos cifras decimales en ambos campos; comprobar conversión exacta. |
| Assumptions | Aceptar monto cero, una persona, propina 0 y 100; no imponer máximos monetarios; comprobar valores superiores a Number.MAX_SAFE_INTEGER con BigInt. |
| SC-003 | Vitest mide hasta el resultado tras act y exige menos de 1000 ms. El navegador mide desde el clic hasta dos frames de renderizado mediante performance.now, comprueba la salida y exige menos de 1000 ms. No sustituir tiempo real de UI por un benchmark del dominio. |
| SC-004 | Toda salida válida de la matriz tiene exactamente dos decimales, «por persona» y ningún símbolo monetario. |
| Constitución | Misma batería de contrato para estrategias; cálculo sin validación/formato; dependencia inyectada; dominio sin React/DOM y presentación sin data. |

Cada caso inválido se ejecuta después de obtener un resultado válido para comprobar
su ausencia posterior, además de verificar el texto del error. Se prueban precedencia
de errores y gramática elegida como decisiones de diseño, sin atribuirlas a la spec.
