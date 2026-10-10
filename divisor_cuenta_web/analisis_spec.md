# Verificación de la constitución web frente a Flutter

## Fuentes y método

Se comparan `.specify/memory/constitution.md` de este proyecto y la constitución en
`../division_cuenta/.specify/memory/constitution.md`, usando las 44 reglas desglosadas
en `../division_cuenta/analisis_spec.md`, sección 2. Los originales no se modifican.
Este informe es descriptivo y no añade obligaciones.

**Idéntica**: igual obligación, aunque cambien palabras sin alterar su alcance.
**Adaptada en redacción**: conserva el principio y adapta términos o su concreción.
**Reemplazada**: la regla original no permanece como tal. Se indica expresamente
cuando se ha omitido sin sustituto. Omitir por alcance no significa incompatibilidad técnica.

## Comparación regla por regla

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
| 24 | La aplicación es Flutter. | Reemplazada (omitida, sin sustituto normativo) | No puede mantenerse como elección de plataforma en este proyecto React. No se añade un sexto principio «usar React». |
| 25 | Una sola pantalla. | Reemplazada (omitida, sin sustituto) | Sí es portable; se omite de la constitución por alcance. Sigue exigida por la spec web, FR-001. |
| 26 | Usar null safety. | Reemplazada (omitida, sin sustituto) | La garantía de Dart no existe literalmente en JavaScript. Validar nulos sería posible, pero añadir esa regla o imponer TypeScript excede lo solicitado. |
| 27 | Nombres en español. | Reemplazada (omitida, sin sustituto) | Técnicamente puede conservarse; se omite porque no figura entre los principios pedidos. |
| 28 | Avisar antes de añadir paquetes externos. | Reemplazada (omitida, sin sustituto) | Técnicamente puede conservarse; se omite por alcance, no por incompatibilidad con React. |
| 29 | Avisar antes de modificar pubspec.yaml. | Reemplazada (omitida, sin sustituto) | El manifiesto Dart no corresponde a este proyecto. Adaptarlo a package.json sería posible, pero ese control adicional no fue solicitado. |
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

## Resultado

| Clasificación | Cantidad |
|---|---:|
| Idéntica | 29 |
| Adaptada en redacción | 9 |
| Reemplazada por omisión, sin sustituto normativo | 6 |
| Total | 44 |

El análisis previo proponía una portabilidad completa: 34 idénticas, 9 adaptadas y
1 reemplazada. Aquí se verifica la constitución efectivamente solicitada: se omiten
las seis restricciones adicionales y se registran las diferencias de LSP y de pruebas
críticas. Por eso no se copian automáticamente los conteos anteriores.

En las filas 25, 27 y 28 no sería correcto afirmar que la regla original «no se puede
conservar»: sí se puede. Se omite por la instrucción de usar los principios proporcionados.
Las filas 24, 26 y 29 tienen además referencias específicas a Flutter o Dart que no se
conservan literalmente en este proyecto. La omisión constitucional de una regla no
elimina requisitos independientes de la spec.

## Reglas nuevas sin equivalente

- src, JavaScript puro y src/main.jsx tienen equivalentes en las filas 10, 12 y 14.
  Son adaptaciones solicitadas, no invenciones.
- La prohibición del DOM explicita la independencia de plataforma de la fila 13.
  Es necesaria para expresar la frontera web que pidió el usuario y no fue inventada.
- La interfaz de redondeo concreta la fila 5 por instrucción del usuario; no exige
  TypeScript ni otra herramienta.
- El flujo de revisión y Governance conservan las filas 30–44. Son mecanismos de
  revisión y mantenimiento documental de Spec Kit, con equivalente en Flutter.
- Alcance, fechas, versión e informe de sincronización son información documental,
  no nuevas obligaciones de implementación.
- No se incorporan ejemplos del scaffold como CLI, TDD obligatorio, aprobaciones de
  pruebas, observabilidad o umbrales de cobertura: serían reglas no solicitadas.

No se identifican principios inventados. La versión 1.0.0 es la constitución inicial
del proyecto web, no una enmienda de la constitución independiente de Flutter.
Esta verificación documental no certifica el cumplimiento del código actual.

## 8.1 La spec: evidencia de copia y reutilización

Verificación realizada el 2026-10-09. El feature activo se resolvió desde
`.specify/feature.json`: `specs/001-reparto-cuenta`; la variable de entorno
SPECIFY_FEATURE_DIRECTORY no estaba definida. La ruta real de Flutter es
`../division_cuenta/specs/001-reparto-cuenta/spec.md`, no la ruta de ejemplo del ejercicio.

Comando ejecutado desde la raíz de divisor_cuenta_web, con ambas rutas resueltas:

```powershell
git diff --no-index -- "..\division_cuenta\specs\001-reparto-cuenta\spec.md" `
  ".\specs\001-reparto-cuenta\spec.md"
```

Evidencia observada, sin sustituir una diferencia por una descripción:

```text
stdout: vacío (0 bytes)
stderr: vacío
código de salida: 0
```

Los dos archivos actuales tienen exactamente el mismo SHA-256:

```text
2E7E20D862FFA432CD36479C5042803673903125FC6DE56B3D3709C09DBC3220
```

Se conservaron las instantáneas de ambos archivos comparados, la salida vacía del diff,
el registro JSON con rutas absolutas y el blob inicial de React extraído del primer
commit que incorporó la spec, `219882fd743eb42c07e4e8fd6739f83f3f313bd5`.
El diff entre Flutter y ese blob inicial también devuelve código 0 y salida estándar
vacía. Git avisa únicamente de LF/CRLF para el blob histórico. Su hash de bytes difiere
del archivo de trabajo por esa conversión; el texto es igual al normalizar LF/CRLF.
La igualdad de bytes se afirma entre los dos archivos actuales, no entre el blob LF y
el archivo CRLF. La evidencia se obtuvo ahora; no se presenta como captura realizada
en la fecha del commit inicial.

Archivos guardados en
[evidencia-spec](specs/001-reparto-cuenta/evidencia-spec/README.md).

### Estimación de reutilización

Se aplica el inventario de la sección 1 de `../division_cuenta/analisis_spec.md`,
conservado también en
[inventario-enunciados.md](specs/001-reparto-cuenta/evidencia-spec/inventario-enunciados.md).
Cada obligación independiente o escenario cuenta como un enunciado; se incluyen entrada,
historias, escenarios, casos límite, FR, entidades, SC y supuestos. Las repeticiones se
cuentan en cada aparición; se excluyen títulos y metadatos. Este conteo es independiente
de las 44 reglas constitucionales comparadas anteriormente.

| Resultado | Enunciados |
|---|---:|
| Reutilizados sin cambios (QUÉ / Intacto) | 106 |
| Dependientes de Flutter que necesitan sustitución (CÓMO) | 0 |
| Mixtos que necesitan adaptación | 0 |
| Total | 106 |

**Reutilización estimada = 106 / 106 × 100 = 100 %.** Además del análisis semántico,
el diff vacío confirma que el documento completo se copió sin cambios textuales.

### Aplicación del protocolo de adaptación

Se revisaron plan.md, research.md y validacion.md del feature React. No se identificó
un enunciado de la spec que prescriba Flutter, Dart, widgets, Riverpod o pubspec.yaml y
bloquee la migración. Las referencias tecnológicas que requirieron adaptación pertenecen
a la constitución y al diseño, no a esta spec.

El plan React se elaboró con la copia original y la implementación preservó esa copia.
SC-001 cuenta seis escenarios aunque hay siete; la precedencia de errores para personas
negativas fraccionarias necesitó una decisión documentada; la primera carga offline no
tiene procedimiento definido. Son problemas de consistencia o precisión del contrato,
no dependencias de Flutter ni enunciados CÓMO que deban eliminarse para usar React.
El límite de recarga remota offline continúa explícito en la validación: reutilización
del texto no significa garantía de comportamientos que no se implementaron o probaron.

Por tanto, se conserva la copia inicial y su evidencia, pero no corresponde corregir
un enunciado, producir un antes/después de adaptación ni crear un commit de corrección.
Si aparece después un bloqueo específico de Flutter, se documentará aquí primero el
texto original, su carácter CÓMO y el intento de planificar con él; solo posteriormente
se realizará la adaptación en un commit separado, preservando estas instantáneas.
