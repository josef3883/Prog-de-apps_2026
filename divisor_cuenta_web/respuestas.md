# Respuestas: migración de Flutter a React

Verificación: 2026-10-09. Proyecto React: `divisor_cuenta_web`. Proyecto anterior:
`../division_cuenta`. El feature activo es `specs/001-reparto-cuenta`, según
[feature.json](.specify/feature.json); no se usaron las rutas de ejemplo del ejercicio.

## 1. Porcentaje de reutilización de la spec

| Clasificación | Enunciados | Porcentaje |
|---|---:|---:|
| Viajaron intactos | 106 | 100 % |
| Necesitaron adaptación | 0 | 0 % |
| No pudieron reutilizarse | 0 | 0 % |
| Total | 106 | 100 % |

El conteo procede de [analisis_spec.md, sección 8.1](analisis_spec.md#81-la-spec-evidencia-de-copia-y-reutilización)
y del [inventario de los 106 enunciados](specs/001-reparto-cuenta/evidencia-spec/inventario-enunciados.md).
Se cuentan obligaciones independientes y escenarios, incluidas sus repeticiones;
no títulos, metadatos ni líneas físicas. Todos describen comportamiento observable
(QUÉ), sin exigir Dart, widgets, Flutter ni una biblioteca de estado.

La comparación real fue:

```powershell
git diff --no-index -- "..\division_cuenta\specs\001-reparto-cuenta\spec.md" `
  ".\specs\001-reparto-cuenta\spec.md"
```

```text
stdout: vacío (0 bytes)
stderr: vacío
código de salida: 0
```

La [salida original vacía](specs/001-reparto-cuenta/evidencia-spec/diff-spec.txt)
y el [registro con hashes y rutas](specs/001-reparto-cuenta/evidencia-spec/resultado.json)
respaldan la igualdad. Ambos archivos actuales tienen el SHA-256
`2E7E20D862FFA432CD36479C5042803673903125FC6DE56B3D3709C09DBC3220`.
También se conservó la [spec inicial de React extraída de Git](specs/001-reparto-cuenta/evidencia-spec/react-primer-commit.md):
el diff con Flutter es vacío, con una advertencia de conversión LF/CRLF documentada.
La evidencia histórica se obtuvo después; no es una captura contemporánea al primer commit.

No hay una medición registrada del tiempo de desarrollo que permita comparar enfoques.
Los tiempos de respuesta de la aplicación registrados en
[validacion.md](specs/001-reparto-cuenta/validacion.md#navegador-real-offline-y-tiempo)
miden clic a renderizado, no trabajo de migración. La ejecución actual de `npm test`
duró 6.79 s; tampoco representa el tiempo de desarrollo ni demuestra por sí sola calidad.

## 2. Constitution: clasificación de cada regla

Se comparan las constituciones efectivamente existentes:
[Flutter](../division_cuenta/.specify/memory/constitution.md) y
[React](.specify/memory/constitution.md). La tabla reproduce el desglose de 44 reglas
de [analisis_spec.md](analisis_spec.md#comparación-regla-por-regla).
Las referencias I–V corresponden a las secciones homónimas de **ambos** documentos;
las filas 24–29 contrastan «Restricciones del proyecto» de Flutter con «Alcance» de React;
las filas 30–32 corresponden a «Flujo de desarrollo y revisión» y 33–44 a «Governance».
El [diff completo de las constituciones](specs/001-reparto-cuenta/evidencia-respuestas/diff-constitution.txt)
permite comprobar el texto de origen y destino.

«Idéntica» significa igual obligación, aunque una paráfrasis no sea copia literal.
«Adaptada en redacción» conserva el principio, con las diferencias de alcance indicadas.
«Reemplazada» incluye aquí una omisión sin sustituto; no implica que React la haga imposible.

| N.º | Regla de Flutter | Clasificación | Resultado web y justificación |
|---|---|---|---|
| 1 | SRP: cada clase tiene una razón de cambio. | Adaptada en redacción | I: función o módulo; conserva SRP sin exigir clases. |
| 2 | El cálculo no valida. | Idéntica | I lo conserva. |
| 3 | El cálculo no formatea. | Idéntica | I lo conserva. |
| 4 | OCP: añadir redondeos sin modificar clases existentes. | Adaptada en redacción | I sustituye clases por módulos. No se introduce una excepción al texto solicitado. |
| 5 | LSP: implementaciones de una interfaz sustituibles sin comprobar tipos. | Adaptada en redacción | I concreta la interfaz en redondeo por instrucción del usuario; Flutter tenía una formulación más general. |
| 6 | ISP: interfaces pequeñas. | Idéntica | I lo conserva. |
| 7 | ISP: no depender de métodos que no se usan. | Idéntica | I usa funciones; conserva la obligación. |
| 8 | DIP: presentación depende de abstracciones del dominio. | Idéntica | I lo conserva. |
| 9 | DIP: presentación no depende de clases concretas de datos. | Adaptada en redacción | I habla de implementaciones, también si son funciones u objetos. |
| 10 | Capas lib/presentation, lib/domain y lib/data. | Adaptada en redacción | II cambia la raíz a src y mantiene las tres capas. |
| 11 | presentation -> domain <- data. | Idéntica | II conserva la dirección. |
| 12 | lib/domain es Dart puro. | Adaptada en redacción | II: src/domain es JavaScript puro; conserva la autonomía del dominio. |
| 13 | El dominio no importa package:flutter. | Adaptada en redacción | II prohíbe react y todo lo relacionado con el DOM, según la frontera web solicitada. |
| 14 | main.dart es el único lugar de instanciación concreta. | Adaptada en redacción | II designa src/main.jsx; conserva un único punto de composición. |
| 15 | Nunca guardar secretos en el repositorio. | Idéntica | III lo conserva. |
| 16 | Nunca guardar claves de API en el repositorio. | Idéntica | III lo conserva como API keys. |
| 17 | Funcionalidad crítica con pruebas ejecutables. | Adaptada en redacción | IV reproduce «tiene pruebas» del usuario. No añade el adjetivo omitido; las pruebas ejecutables sí se exigen expresamente para la aceptación. |
| 18 | Criterios de aceptación convertidos en pruebas ejecutables. | Idéntica | IV lo conserva. |
| 19 | El estudiante explica qué hace cada función generada. | Idéntica | V lo conserva. |
| 20 | El estudiante explica por qué existe cada función generada. | Idéntica | V lo conserva. |
| 21 | El estudiante explica qué recibe cada función generada. | Idéntica | V lo conserva. |
| 22 | El estudiante explica qué devuelve cada función generada. | Idéntica | V lo conserva. |
| 23 | El estudiante explica qué errores produce cada función generada. | Idéntica | V lo conserva. |
| 24 | La aplicación es Flutter. | Reemplazada | No puede mantenerse como elección de plataforma en este proyecto React. No se añade un sexto principio «usar React». |
| 25 | Una sola pantalla. | Reemplazada | Sí es portable; se omite de la constitución por alcance. Sigue exigida por la spec web, FR-001. |
| 26 | Usar null safety. | Reemplazada | La garantía de Dart no existe literalmente en JavaScript. Validar nulos sería posible, pero añadir esa regla o imponer TypeScript excede lo solicitado. |
| 27 | Nombres en español. | Reemplazada | Técnicamente puede conservarse; se omite porque no figura entre los principios pedidos. |
| 28 | Avisar antes de añadir paquetes externos. | Reemplazada | Técnicamente puede conservarse; se omite por alcance, no por incompatibilidad con React. |
| 29 | Avisar antes de modificar pubspec.yaml. | Reemplazada | El manifiesto Dart no corresponde a este proyecto. Adaptarlo a package.json sería posible, pero ese control adicional no fue solicitado. |
| 30 | Revisar principios antes de aceptar cambios. | Idéntica | Flujo de desarrollo y revisión lo conserva. |
| 31 | Revisar cobertura de funcionalidades críticas. | Idéntica | Se conserva la comprobación de cobertura; la diferencia sobre «ejecutables» está en la fila 17. |
| 32 | Revisar cobertura de criterios de aceptación. | Idéntica | Flujo de desarrollo y revisión lo conserva. |
| 33 | La constitución rige decisiones y revisiones. | Idéntica | Governance lo conserva. |
| 34 | Enmiendas indican su motivo. | Idéntica | Governance lo conserva. |
| 35 | Enmiendas indican secciones afectadas. | Idéntica | Governance lo conserva. |
| 36 | Enmiendas actualizan la versión. | Idéntica | Governance lo conserva. |
| 37 | Enmiendas actualizan la fecha de modificación. | Idéntica | Governance lo conserva. |
| 38 | Revisar enmiendas frente a principios aplicables. | Idéntica | Governance lo conserva. |
| 39 | Revisar enmiendas frente a pruebas. | Idéntica | Governance lo conserva. |
| 40 | Versionado SemVer. | Idéntica | Governance lo conserva. |
| 41 | MAJOR para retirar o redefinir incompatiblemente principios. | Idéntica | Governance lo conserva. |
| 42 | MINOR para añadir principios/secciones o ampliar materialmente reglas. | Idéntica | Governance lo conserva como mantenimiento documental; no autoriza a inventar principios. |
| 43 | PATCH para aclaraciones y cambios editoriales no semánticos. | Idéntica | Governance lo conserva. |
| 44 | Revisiones verifican cumplimiento constitucional. | Idéntica | Governance lo conserva. |

Resultado: **29 idénticas, 9 adaptadas en redacción y 6 reemplazadas por omisión**.
Las 15 reglas con diferencias se distinguen de las 0 modificaciones de la spec.
El análisis del proyecto Flutter proponía 34/9/1 para una migración hipotética;
el conteo 29/9/6 verifica la constitución React que realmente se solicitó y escribió.

Ejemplos textuales que permiten verificar las adaptaciones:

- Flutter I: «Cada clase DEBE tener una sola razón de cambio»; React I:
  «una función o módulo, una razón de cambio». Cambia la unidad de organización, conserva SRP.
- Flutter II: «`lib/domain/` DEBE ser Dart puro» y no importar `package:flutter`;
  React II: «`src/domain/` NO importa `react` ni nada del DOM: es JavaScript puro».
  Se conserva la independencia de la interfaz.
- Flutter IV exige «pruebas ejecutables» para funcionalidad crítica; React IV dice
  «tener pruebas». Por fidelidad a lo solicitado se registra esa diferencia textual;
  ambos exigen expresamente pruebas ejecutables para los criterios de aceptación.

Las omisiones de «una sola pantalla», nombres en español y aviso de paquetes podían
conservarse técnicamente; se omitieron por el alcance de los principios pedidos.
Flutter, null safety de Dart y `pubspec.yaml` tienen referencias tecnológicas que no
se trasladan literalmente. FR-001 sigue exigiendo una sola pantalla aunque esa regla
no figure en la constitución React. No se identifican principios nuevos inventados:
la prohibición del DOM fue solicitada y adapta la frontera del dominio; revisión y
gobernanza ya existían en Flutter.

## 3. ¿Hubo que modificar la spec para implementar React?

**No.** La [spec Flutter](../division_cuenta/specs/001-reparto-cuenta/spec.md) y
la [spec React](specs/001-reparto-cuenta/spec.md) conservan el mismo texto.
Describen entradas, fórmulas, redondeos, mensajes, formato, eventos de cálculo y
funcionamiento local. No prescriben cómo construir la pantalla o manejar su estado.
Las decisiones de Dart/Flutter estaban en la constitución y el plan; pudieron
adaptarse allí sin cambiar los resultados exigidos.

El [plan React](specs/001-reparto-cuenta/plan.md#discrepancias-y-decisiones-explícitas)
registra la discrepancia de SC-001: dice seis escenarios, pero las historias suman
cuatro de cálculo, dos de errores y uno offline. Se probaron los siete sin editar
la spec. Es una inconsistencia original de conteo, no una dependencia de Flutter.
Tampoco fue necesario cambiar «entero siguiente»: los supuestos ya aclaran que
un importe entero no aumenta.

Por eso no hay una versión corregida ni un commit separado de adaptación de la spec.
Se preservaron la copia inicial y la evidencia del diff vacío, como documenta
[analisis_spec.md](analisis_spec.md#aplicación-del-protocolo-de-adaptación).
La validación offline de React cubre recursos ya cargados o servidos localmente;
no se afirma haber probado primera apertura o recarga remota sin conexión.
Ese límite está documentado en [validacion.md](specs/001-reparto-cuenta/validacion.md).

## 4. Comparación de los seis casos de aceptación

La comparación directa usa [casos_de_prueba.dart](../division_cuenta/test/casos_de_prueba.dart)
y [casosDePrueba.js](test/casosDePrueba.js). **No cambió ningún valor esperado,
mensaje ni escenario de esos seis casos.**

| Caso | Entrada / modo en ambos proyectos | Esperado Flutter | Esperado React |
|---|---|---|---|
| Reparto normal | 100.00; 4 personas; 10 %; exacto | 27.50 | 27.50 |
| Sin propina | 90.00; 3 personas; 0 %; exacto | 30.00 | 30.00 |
| Cero personas | 50.00; 0 personas; 0 %; exacto | Debe haber al menos una persona | Debe haber al menos una persona |
| Monto no numérico | NaN; 4 personas; 0 %; exacto | Monto inválido | Monto inválido |
| Redondeo exacto | 10.00; 3 personas; 0 %; exacto | 3.33 | 3.33 |
| Redondeo hacia arriba | 10.00; 3 personas; 0 %; arriba | 4.00 | 4.00 |

`double.nan` se representa como `NaN` en JavaScript: cambia la sintaxis del dato,
no su significado ni el error esperado. El escenario de pantalla con texto `abc`
también se conserva en [pantalla_test.dart](../division_cuenta/test/pantalla_test.dart)
y [pantalla.test.jsx](test/pantalla.test.jsx); no se reemplazó `abc` por NaN en la spec.

[division_test.dart](../division_cuenta/test/division_test.dart) y
[division.test.js](test/division.test.js) recorren los casos y verifican los resultados;
la suite React también demuestra sustitución LSP. Las pruebas UI verifican mensajes
y ausencia de resultado. La ejecución actual de `npm test` terminó con
**14 archivos y 146 pruebas aprobadas**, incluidos los seis casos y las tres pruebas
de Testing Library. Esta verificación ejecutó React; no se volvió a ejecutar Flutter.

El escenario offline adicional permanece en ambas specs y tiene pruebas React en
[sinConexion.test.jsx](tests/presentation/sinConexion.test.jsx), además de la
validación en navegador documentada. La diferencia «seis frente a siete» proviene
del documento original, no de una necesidad tecnológica de React.

## 5. Partes del plan Flutter que dejaron de tener sentido en React

Fuentes: [plan Flutter](../division_cuenta/specs/001-reparto-cuenta/plan.md),
[plan React](specs/001-reparto-cuenta/plan.md) y su
[diff completo](specs/001-reparto-cuenta/evidencia-respuestas/diff-plan.txt).

| Decisión Flutter | Adaptación React y motivo |
|---|---|
| Dart 3.13.1, Flutter 3.47.1 y dependencias Flutter SDK/Dart core | JavaScript ESM/JSX, React y Vite. El navegador usa el bundle web; el SDK Flutter no construye esta aplicación. Las versiones declaradas están en el contexto técnico del plan. |
| `PantallaDivisor` con estado temporal mediante `setState` | `PantallaDivisor.jsx` y `useDivisor.js` usan `useState`. Es el mecanismo del componente funcional solicitado; no se añade una biblioteca de estado. |
| `DivisorController` recibe dependencias en el constructor | `useDivisor({ validarEntrada, calcularDivision, formatearMoneda, modos })` recibe funciones y catálogo. Conserva inyección y coordinación sin exigir una clase Dart. |
| `lib/`, módulos `.dart` y composición en `main.dart` | Tres capas bajo `src/`, módulos `.js`/`.jsx` y composición en `src/main.jsx`. Se conserva `presentation -> domain <- data`. |
| Pruebas con `flutter_test` | Vitest con Node para dominio y jsdom para UI. Las pruebas adicionales solicitadas usan Testing Library. `test/pantalla.test.jsx` tiene la directiva jsdom. El plan inicial usaba `act` sin esta biblioteca; las pruebas posteriores ampliaron las herramientas, no los resultados exigidos. |
| Null safety y conservación de `pubspec.yaml`; no tocar `android/`/`ios/` | JavaScript no ofrece literalmente la garantía de Dart; se documentan contratos JSDoc y se valida entrada. Dependencias y scripts están en `package.json`, con configuración de Vite. Los directorios móviles y el manifiesto Dart no forman parte del proyecto web. |

Ejemplos implementados: [hook](src/presentation/useDivisor.js),
[pantalla](src/presentation/PantallaDivisor.jsx), [composición](src/main.jsx),
[contrato de redondeo](src/domain/estrategiaRedondeo.js) y [package.json](package.json).
El contrato Dart `calcularParte(...)` se adapta a `aplicar(valor)`; el cálculo sigue
consumiendo una estrategia intercambiable. La precisión se realiza con centavos BigInt
y racionales, conservando los resultados monetarios exigidos.

El permiso previo para editar `test/` era una instrucción local del proyecto Flutter,
no una limitación tecnológica: no debe presentarse su desaparición como una exigencia
de React. En este proyecto las pruebas fueron expresamente solicitadas por el usuario.

## 6. Artefacto más reusable y menos reusable

**El más reusable fue la spec.** Viajó completa: 106/106 enunciados, 100 % intactos,
diff vacío e igualdad de hashes. El primer commit que la incorporó fue
`219882fd743eb42c07e4e8fd6739f83f3f313bd5`; su blob conservado también coincide
en texto al normalizar LF/CRLF. Los seis casos mantienen números y mensajes, y
las pruebas ejecutables de React verifican ese contrato. Evidencia:
[inventario](specs/001-reparto-cuenta/evidencia-spec/inventario-enunciados.md),
[registro de comparación](specs/001-reparto-cuenta/evidencia-spec/resultado.json)
y [pruebas de división](test/division.test.js).

**Entre spec, constitución y plan, el menos reusable fue el plan de implementación.**
La constitución conservó sus principios y gobernanza: 29 reglas idénticas y 9 adaptadas,
con 6 omisiones explicadas por alcance o referencias tecnológicas. El plan, en cambio,
debió rediseñar lenguaje, herramientas de construcción, plataforma, mecanismo de estado,
controlador, contrato concreto, módulos, configuración y framework de pruebas.
Su [diff](specs/001-reparto-cuenta/evidencia-respuestas/diff-plan.txt)
y los ejemplos de la respuesta 5 muestran esas decisiones. Aun así, conservó arquitectura,
inyección, separación de responsabilidades y objetivos funcionales. No se equipara
el tamaño del diff en líneas con una medida de calidad o de esfuerzo.

Si se incluye el código como artefacto, la presentación Flutter tampoco era copiable
directamente: [pantalla_divisor.dart](../division_cuenta/lib/presentation/pantalla_divisor.dart)
se implementó con JSX en [PantallaDivisor.jsx](src/presentation/PantallaDivisor.jsx).
Eso refuerza la distinción entre reutilizar el contrato y reutilizar su implementación.

Los [registros de los tres diffs](specs/001-reparto-cuenta/evidencia-respuestas/resultado.json)
incluyen rutas reales, hashes y códigos de salida. Código 0 significa igualdad en la spec;
código 1 significa diferencias en constitución y plan, no un fallo de ejecución.
