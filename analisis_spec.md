# Análisis de portabilidad de la spec y la constitución a React

## Método y alcance

Documentos analizados: `specs/001-reparto-cuenta/spec.md` y `.specify/memory/constitution.md`, tal como están escritos. No se modifican los originales. `research.md` contiene decisiones de implementación y no forma parte del porcentaje de la spec.

Para cada enunciado se aplica una sola pregunta: **¿Este enunciado seguiría siendo válido si la app estuviera hecha en React?**

- **QUÉ / Intacto:** conserva su significado y exigencia sin depender del framework.
- **CÓMO / No viaja:** prescribe una implementación específica que no se conserva al pasar a React.
- **MIXTO / Adaptado:** conserva un principio, pero necesita cambiar términos específicos de su implementación.

Cada fila representa un requisito, regla o criterio independiente. Se separan obligaciones diferentes dentro de una misma viñeta; se conserva como unidad cada escenario dado/cuando/entonces y cada caso de rechazo con su respuesta observable. Los enunciados se transcriben de forma condensada, conservando las condiciones y obligaciones relevantes. La referencia inicial permite ubicarlos en el original.

Se incluyen los requisitos de la descripción de entrada, las historias, sus pruebas independientes, escenarios, casos límite, FR, entidades, SC y supuestos. Una regla repetida en secciones distintas se cuenta en cada aparición; no se deduplican los documentos. Se excluyen títulos, prioridades, metadatos, informes de sincronización y explicaciones de propósito que no añaden una obligación. Los nombres de entidades describen información del negocio, sin exigir clases concretas.

## 1. Spec: comportamiento externo

| Enunciado de la spec | Tipo (QUÉ/CÓMO/MIXTO) | ¿Viaja a React? | Justificación |
|---|---|---|---|
| Input: app de una sola pantalla para dividir una cuenta de restaurante entre varias personas. | QUÉ | Intacto | El alcance de la interacción y el propósito no dependen del framework. |
| Input: ingresar monto total, número de personas y porcentaje de propina. | QUÉ | Intacto | Define los datos de entrada. |
| Input: al tocar Calcular se muestra cuánto paga cada persona con dos decimales. | QUÉ | Intacto | Define un disparador y su salida observable. |
| Input: elegir modo exacto o redondeo hacia arriba al entero más cercano. | QUÉ | Intacto | Ofrece dos políticas de negocio. |
| Input: funcionar sin conexión. | QUÉ | Intacto | La disponibilidad offline también puede exigirse a una app React. |
| Input: funcionar sin red. | QUÉ | Intacto | Restringe el uso de servicios, sin elegir una tecnología. |
| Input: funcionar sin base de datos. | QUÉ | Intacto | La ausencia de persistencia sigue siendo una restricción válida. |
| Historia 1: introducir total, personas y propina. | QUÉ | Intacto | Describe información aportada por la persona. |
| Historia 1: elegir cómo redondear. | QUÉ | Intacto | Describe una elección funcional. |
| Historia 1: calcular la parte individual para saber cuánto paga cada persona. | QUÉ | Intacto | Expresa el objetivo del cálculo. |
| Prueba independiente 1: introducir datos válidos, seleccionar cualquiera de los modos y tocar Calcular; aparece el importe por persona con dos decimales. | QUÉ | Intacto | El criterio se verifica desde la interacción, sin exigir una herramienta. |
| Escenario 1.1: 100.00, 4 personas, 10 % y modo exacto producen 27.50 por persona al calcular. | QUÉ | Intacto | Es un ejemplo verificable del negocio. |
| Escenario 1.2: 90.00, 3 personas, 0 % y modo exacto producen 30.00 por persona al calcular. | QUÉ | Intacto | La salida esperada es independiente de la UI. |
| Escenario 1.3: 10.00, 3 personas, 0 % y modo exacto producen 3.33 por persona al calcular. | QUÉ | Intacto | Verifica precisión y reparto. |
| Escenario 1.4: 10.00, 3 personas, 0 % y modo hacia arriba producen 4.00 por persona al calcular. | QUÉ | Intacto | Verifica una política monetaria. |
| Historia 2: recibir un mensaje claro ante un dato que impide calcular, para corregirlo sin confundirlo con un resultado válido. | QUÉ | Intacto | Es comportamiento de validación visible. |
| Prueba independiente 2: calcular con cero personas y comprobar el mensaje correspondiente y la ausencia de resultado. | QUÉ | Intacto | Define un rechazo comprobable. |
| Prueba independiente 2: calcular con monto no numérico y comprobar el mensaje correspondiente y la ausencia de resultado. | QUÉ | Intacto | Es otro caso independiente de rechazo. |
| Escenario 2.1: total 50.00 y 0 personas muestran «Debe haber al menos una persona» y ningún resultado al calcular. | QUÉ | Intacto | El mensaje y la salida son parte del contrato externo. |
| Escenario 2.2: monto «abc» muestra «Monto inválido» y ningún resultado al calcular. | QUÉ | Intacto | El error no depende de Flutter. |
| Historia 3: calcular sin conexión y sin depender de un servicio externo. | QUÉ | Intacto | Define disponibilidad funcional. |
| Prueba independiente 3: desactivar la conexión, introducir datos válidos y comprobar el importe al calcular. | QUÉ | Intacto | Puede comprobarse en cualquier plataforma objetivo. |
| Escenario 3.1: sin conexión, un reparto válido muestra su resultado sin solicitar red ni almacenamiento externo. | QUÉ | Intacto | Es una condición y una respuesta observable completas. |
| Edge Cases, monto: aceptar punto o coma como separador decimal. | QUÉ | Intacto | Es una regla del formato de entrada. |
| Edge Cases, monto: no admitir separadores de miles. | QUÉ | Intacto | Es una restricción de entrada. |
| Edge Cases, monto: admitir hasta dos decimales. | QUÉ | Intacto | Define precisión permitida. |
| Edge Cases, monto: si está vacío, mostrar «Monto inválido» y ocultar el resultado anterior al calcular. | QUÉ | Intacto | Define un caso de rechazo y su efecto. |
| Edge Cases, monto: si es negativo, mostrar «Monto inválido» y ocultar el resultado anterior al calcular. | QUÉ | Intacto | El límite monetario no depende del lenguaje. |
| Edge Cases, monto: si no es numérico, mostrar «Monto inválido» y ocultar el resultado anterior al calcular. | QUÉ | Intacto | Define validez de entrada. |
| Edge Cases, monto: si no es finito, mostrar «Monto inválido» y ocultar el resultado anterior al calcular. | QUÉ | Intacto | La finitud es una condición matemática portable. |
| Edge Cases, monto: si excede dos decimales, mostrar «Monto inválido» y ocultar el resultado anterior al calcular. | QUÉ | Intacto | La precisión aceptada es una regla de negocio. |
| Edge Cases, personas: exigir un entero positivo. | QUÉ | Intacto | Define el conjunto de valores válidos. |
| Edge Cases, personas: cero o un negativo muestran «Debe haber al menos una persona». | QUÉ | Intacto | Ambos valores comparten la misma condición de rechazo: no ser positivos. |
| Edge Cases, personas: un valor no entero muestra «Número de personas inválido». | QUÉ | Intacto | Una cantidad fraccionaria incumple el contrato. |
| Edge Cases, personas: un valor no numérico muestra «Número de personas inválido». | QUÉ | Intacto | Es otro caso de entrada inválida. |
| Edge Cases, propina: aceptar punto o coma decimal. | QUÉ | Intacto | Regula la entrada textual. |
| Edge Cases, propina: no admitir separadores de miles. | QUÉ | Intacto | Es una restricción del formato. |
| Edge Cases, propina: exigir un valor numérico. | QUÉ | Intacto | Define validez matemática. |
| Edge Cases, propina: exigir un valor finito. | QUÉ | Intacto | No prescribe una representación numérica concreta. |
| Edge Cases, propina: exigir un valor de 0 a 100 inclusive. | QUÉ | Intacto | Define límites del negocio. |
| Edge Cases, propina: admitir hasta dos decimales. | QUÉ | Intacto | Define precisión de entrada. |
| Edge Cases, propina: incumplir sus condiciones muestra «Propina inválida» y oculta todo resultado. | QUÉ | Intacto | Define la respuesta común ante las condiciones anteriores. |
| Edge Cases: el modo hacia arriba conserva un importe ya entero. | QUÉ | Intacto | Determina el comportamiento en un límite matemático. |
| Edge Cases: ese importe entero se muestra con dos decimales. | QUÉ | Intacto | Es formato de salida. |
| Edge Cases: cambiar datos tras calcular exige volver a tocar Calcular para actualizar el resultado. | QUÉ | Intacto | Define cuándo se actualiza la salida. |
| FR-001: permitir ingresar monto, personas y propina en una sola pantalla. | QUÉ | Intacto | Describe una interacción, sin exigir widgets ni componentes. |
| FR-002: ofrecer modo exacto y modo hacia arriba al entero monetario siguiente. | QUÉ | Intacto | Define las opciones funcionales. |
| FR-003: calcular únicamente al tocar Calcular. | QUÉ | Intacto | El evento de usuario es independiente del framework. |
| FR-004: sumar al monto la propina porcentual. | QUÉ | Intacto | Es la primera operación de la regla monetaria. |
| FR-004: dividir el total resultante entre la cantidad de personas. | QUÉ | Intacto | Es la regla de reparto. |
| FR-005: en modo exacto, mostrar el importe individual con dos decimales. | QUÉ | Intacto | Es formato verificable. |
| FR-005: redondear al centésimo más cercano. | QUÉ | Intacto | Es una regla matemática, no una librería. |
| FR-005: en un empate entre centésimos, redondear hacia arriba. | QUÉ | Intacto | Precisa la política de desempate. |
| FR-006: en modo hacia arriba, redondear el importe individual al entero monetario siguiente. | QUÉ | Intacto | Prescribe el resultado monetario. |
| FR-006: mostrar el resultado con dos decimales. | QUÉ | Intacto | Conserva el contrato de presentación. |
| FR-007: cero personas muestra «Debe haber al menos una persona» y ningún resultado. | QUÉ | Intacto | Es validación externa. |
| FR-008: monto vacío muestra «Monto inválido» y oculta cualquier resultado. | QUÉ | Intacto | Caso de rechazo independiente. |
| FR-008: monto negativo muestra «Monto inválido» y oculta cualquier resultado. | QUÉ | Intacto | Caso de rechazo independiente. |
| FR-008: monto no finito muestra «Monto inválido» y oculta cualquier resultado. | QUÉ | Intacto | Restricción matemática portable. |
| FR-008: monto no numérico, como «abc», muestra «Monto inválido» y oculta cualquier resultado. | QUÉ | Intacto | Define una respuesta a texto inválido. |
| FR-008: monto con separadores de miles muestra «Monto inválido» y oculta cualquier resultado. | QUÉ | Intacto | Define un formato prohibido. |
| FR-008: monto con más de dos decimales muestra «Monto inválido» y oculta cualquier resultado. | QUÉ | Intacto | Define una precisión prohibida. |
| FR-009: cero o menos personas muestra «Debe haber al menos una persona». | QUÉ | Intacto | Define el rechazo de cantidades no positivas. |
| FR-009: cantidad no entera muestra «Número de personas inválido». | QUÉ | Intacto | Es validación del dato. |
| FR-009: cantidad no numérica muestra «Número de personas inválido». | QUÉ | Intacto | Es validación del dato. |
| FR-009: propina no numérica muestra «Propina inválida». | QUÉ | Intacto | Es un caso de rechazo independiente. |
| FR-009: propina no finita muestra «Propina inválida». | QUÉ | Intacto | Es un caso de rechazo independiente. |
| FR-009: propina con separadores de miles muestra «Propina inválida». | QUÉ | Intacto | Es una restricción textual. |
| FR-009: propina con más de dos decimales muestra «Propina inválida». | QUÉ | Intacto | Es una restricción de precisión. |
| FR-009: propina fuera de 0 a 100 muestra «Propina inválida». | QUÉ | Intacto | Es una restricción del rango. |
| FR-009: en todos esos errores, ocultar cualquier resultado. | QUÉ | Intacto | Define el estado visible después de fallar. |
| FR-010: calcular sin conexión. | QUÉ | Intacto | Exige disponibilidad offline. |
| FR-010: no enviar solicitudes de red para calcular. | QUÉ | Intacto | Define una restricción comprobable del cálculo. |
| FR-010: no guardar la cuenta en una base de datos. | QUÉ | Intacto | Restringe la persistencia sin elegir almacenamiento. |
| FR-011: monto y propina aceptan punto o coma decimal. | QUÉ | Intacto | El formato de ambos campos es parte del contrato externo. |
| FR-011: monto y propina admiten hasta dos cifras decimales. | QUÉ | Intacto | Define precisión de entrada común. |
| FR-011: monto y propina rechazan separadores de miles. | QUÉ | Intacto | Define una validación común. |
| Entidades: la solicitud contiene total, número de personas, propina y modo introducidos para un cálculo. | QUÉ | Intacto | Describe datos del negocio; no exige una clase Dart. |
| Entidades: el resultado contiene el importe individual obtenido de una solicitud válida. | QUÉ | Intacto | Describe el significado del resultado. |
| Entidades: el resultado se expresa con dos decimales. | QUÉ | Intacto | Define precisión observable. |
| SC-001: los seis escenarios proporcionados producen el importe o mensaje especificado en 6 de 6 ejecuciones. | QUÉ | Intacto | Es verificable en React, aunque su conteo contradice los siete escenarios listados. |
| SC-002: cada categoría de entrada inválida de Edge Cases tiene al menos una prueba ejecutable. | QUÉ | Intacto | Exige cobertura sin prescribir una herramienta. |
| SC-002: esas pruebas verifican el mensaje correspondiente. | QUÉ | Intacto | Define una comprobación de salida. |
| SC-002: esas pruebas verifican la ausencia de resultado. | QUÉ | Intacto | Define otra comprobación de salida. |
| SC-003: con datos válidos, el importe aparece antes de un segundo desde Calcular, medido con cronómetro. | QUÉ | Intacto | Es un criterio de rendimiento y un método de medición portable. |
| SC-004: todos los resultados válidos identifican el importe como «por persona». | QUÉ | Intacto | Es una exigencia de claridad de la salida. |
| SC-004: todos los resultados válidos tienen exactamente dos decimales. | QUÉ | Intacto | Es una exigencia de formato. |
| Supuestos: la propina se calcula sobre el monto total antes de dividir. | QUÉ | Intacto | Define el orden del cálculo. |
| Supuestos: montos y porcentajes admiten punto o coma decimal. | QUÉ | Intacto | Define entradas aceptadas. |
| Supuestos: montos y porcentajes admiten hasta dos decimales. | QUÉ | Intacto | Define precisión aceptada. |
| Supuestos: no se admiten separadores de miles. | QUÉ | Intacto | Define un formato rechazado. |
| Supuestos: el importe de propina se redondea al centésimo más cercano. | QUÉ | Intacto | Es una regla monetaria. |
| Supuestos: los empates de la propina se redondean hacia arriba. | QUÉ | Intacto | Es una regla de desempate. |
| Supuestos: el modo exacto conserva la mayor precisión del reparto. | QUÉ | Intacto | Exige precisión sin imponer un tipo numérico o algoritmo. |
| Supuestos: el modo exacto presenta el importe individual al centésimo más cercano. | QUÉ | Intacto | Define el redondeo de salida. |
| Supuestos: los empates del importe individual se redondean hacia arriba. | QUÉ | Intacto | Define el desempate de salida. |
| Supuestos: el modo hacia arriba se aplica al importe final individual tras añadir propina y dividir. | QUÉ | Intacto | Define el orden de operaciones. |
| Supuestos: un importe ya entero no aumenta. | QUÉ | Intacto | Define un caso límite del redondeo. |
| Supuestos: no se fija una moneda. | QUÉ | Intacto | Limita el alcance del negocio. |
| Supuestos: no se muestra un símbolo monetario. | QUÉ | Intacto | Define lo que ve la persona. |
| Supuestos: el importe se presenta como número con dos decimales. | QUÉ | Intacto | Es formato independiente del framework. |
| Supuestos: se aceptan montos no negativos. | QUÉ | Intacto | Define un límite de entrada. |
| Supuestos: la propina debe estar entre 0 y 100 inclusive. | QUÉ | Intacto | Define un rango de negocio. |
| Supuestos: personas debe ser un entero positivo. | QUÉ | Intacto | Define un dominio de entrada. |
| Supuestos: la cuenta se utiliza solo durante la sesión actual. | QUÉ | Intacto | Define el ciclo de vida de la información. |
| Supuestos: la cuenta no se persiste. | QUÉ | Intacto | Restringe la conservación de los datos. |

### Conteo de la spec

| Categoría | Cantidad |
|---|---:|
| QUÉ | 106 |
| CÓMO | 0 |
| MIXTO | 0 |
| Total de enunciados analizados | 106 |

```text
% CÓMO = (cantidad CÓMO / total de enunciados analizados) × 100
       = (0 / 106) × 100
       = 0 %
```

Los MIXTOS se reportan aparte: **0 de 106 (0 %)**; no forman parte del numerador CÓMO.

La prohibición de red o base de datos no se clasifica automáticamente como CÓMO: sigue siendo exigible en React y no prescribe una librería, un componente ni una técnica para cumplirla. Lo mismo ocurre con las pruebas ejecutables, la finitud numérica y las reglas de redondeo. La spec no prescribe Riverpod, widgets, imports, carpetas o clases Flutter.

## 2. Constitution: arquitectura y calidad

En esta tabla se conserva el tipo para hacer explícita la misma pregunta. La tercera columna clasifica el destino de cada regla como **idéntica**, **adaptada en redacción** o **reemplazada**. Las alternativas son propuestas para una eventual versión React, no modificaciones realizadas ni decisiones de implementación ya aprobadas.

| Enunciado de la Constitution | Tipo (QUÉ/CÓMO/MIXTO) | Clasificación para React | Justificación y redacción propuesta cuando corresponde |
|---|---|---|---|
| I: cada clase debe tener una sola razón de cambio (SRP). | MIXTO | adaptada en redacción | El principio se conserva, pero React no exige clases. Propuesta: cada módulo, función o componente debe tener una responsabilidad y una razón principal de cambio. |
| I: el cálculo no valida. | QUÉ | idéntica | La separación entre validación y cálculo no depende del framework. |
| I: el cálculo no formatea. | QUÉ | idéntica | La separación entre cálculo y formato es reusable. |
| I: agregar una regla de redondeo debe ser posible sin modificar las clases existentes (OCP). | MIXTO | adaptada en redacción | Sustituir «clases existentes» por «módulos existentes que calculan o consumen las políticas»; conservar la extensibilidad, permitiendo registrar la política en el punto de composición. |
| I: cualquier implementación de una interfaz debe sustituir a otra sin que su consumidor compruebe su tipo (LSP). | QUÉ | idéntica | El contrato y la sustitución valen con interfaces o contratos estructurales; no obliga a una sintaxis Dart. |
| I: las interfaces deben ser pequeñas (ISP). | QUÉ | idéntica | El tamaño de los contratos no depende de una tecnología concreta. |
| I: los consumidores no dependen de métodos que no usan (ISP). | QUÉ | idéntica | La restricción de dependencia sigue teniendo el mismo significado. |
| I: la presentación depende de abstracciones del dominio (DIP). | QUÉ | idéntica | React puede consumir contratos del dominio sin cambiar el principio. |
| I: la presentación nunca depende de clases concretas de datos (DIP). | MIXTO | adaptada en redacción | Propuesta: la presentación no depende de implementaciones concretas de la capa de datos. Evita limitar la regla a clases cuando podrían existir funciones u objetos. |
| II: organizar el código en `lib/presentation`, `lib/domain` y `lib/data`. | MIXTO | adaptada en redacción | Conservar las capas y adaptar la raíz al proyecto React; por ejemplo, `src/presentation`, `src/domain` y `src/data`. Es una propuesta de estructura, no una exigencia de React. |
| II: mantener la dirección `presentation -> domain <- data`. | QUÉ | idéntica | La dirección de dependencias es una regla de arquitectura portable. |
| II: `lib/domain/` debe ser Dart puro. | MIXTO | adaptada en redacción | Propuesta: el dominio usa el lenguaje del proyecto y permanece independiente de React y sus adaptadores. Cambia Dart y la ruta, se conserva la autonomía del negocio. |
| II: el dominio no puede importar `package:flutter`. | MIXTO | adaptada en redacción | Propuesta: el dominio no importa `react`, paquetes de UI ni adaptadores de plataforma. Conserva la frontera de dependencias. |
| II: `main.dart` es el único lugar donde se instancian implementaciones concretas. | MIXTO | adaptada en redacción | Propuesta: construir y conectar las implementaciones concretas únicamente en un punto de composición designado. Su nombre se define según el proyecto React; no se exige un archivo Dart. |
| III: nunca guardar secretos en el repositorio. | QUÉ | idéntica | La protección del repositorio sigue aplicando. |
| III: nunca guardar claves de API en el repositorio. | QUÉ | idéntica | El caso concreto de credenciales sigue aplicando. |
| IV: toda funcionalidad crítica debe tener pruebas ejecutables. | QUÉ | idéntica | No impone framework de pruebas. |
| IV: los criterios de aceptación de cada spec deben convertirse en pruebas ejecutables. | QUÉ | idéntica | Es una obligación de verificación reusable. |
| V: el estudiante debe poder explicar qué hace toda función generada por el agente. | QUÉ | idéntica | Es un criterio pedagógico independiente del lenguaje. |
| V: el estudiante debe poder explicar por qué existe cada función generada. | QUÉ | idéntica | Exige comprender su propósito. |
| V: el estudiante debe poder explicar qué recibe cada función generada. | QUÉ | idéntica | Exige comprender las entradas. |
| V: el estudiante debe poder explicar qué devuelve cada función generada. | QUÉ | idéntica | Exige comprender las salidas. |
| V: el estudiante debe poder explicar qué errores produce cada función generada. | QUÉ | idéntica | Exige comprender el comportamiento de error. |
| Restricciones: la aplicación es Flutter. | CÓMO | reemplazada | En una versión React debe decir «La aplicación usa React». Es una elección de tecnología que contradice directamente la plataforma hipotética. |
| Restricciones: la aplicación consta de una sola pantalla. | QUÉ | idéntica | La cantidad de pantallas es alcance funcional. |
| Restricciones: el código debe usar null safety. | MIXTO | adaptada en redacción | En el contexto Dart alude a una garantía concreta del lenguaje. Propuesta: controlar explícitamente valores nulos y ausentes y evitar su uso sin validación. Si se elige TypeScript, `strictNullChecks` puede apoyar esa regla; React por sí solo no lo garantiza. |
| Restricciones: usar nombres en español. | QUÉ | idéntica | Es una convención de calidad que puede mantenerse. |
| Restricciones: no añadir paquetes externos sin avisar antes. | QUÉ | idéntica | Es una regla de revisión de dependencias, sin elegir gestor o librería. |
| Restricciones: no modificar `pubspec.yaml` sin avisar antes. | MIXTO | adaptada en redacción | Propuesta: avisar antes de modificar el manifiesto de dependencias del proyecto, por ejemplo `package.json`. Conserva el control de cambios y sustituye el archivo específico. |
| Flujo: antes de aceptar un cambio, comprobar los principios aplicables. | QUÉ | idéntica | Es una regla de revisión reusable. |
| Flujo: antes de aceptar un cambio, comprobar que las pruebas cubren las funcionalidades críticas. | QUÉ | idéntica | Es una condición de aceptación de cambios. |
| Flujo: antes de aceptar un cambio, comprobar que las pruebas cubren los criterios de aceptación de cada spec. | QUÉ | idéntica | Es otra condición de cobertura verificable. |
| Governance: la constitución rige decisiones y revisiones del proyecto. | QUÉ | idéntica | La autoridad del documento no depende del framework. |
| Governance: toda enmienda indica su motivo. | QUÉ | idéntica | Es trazabilidad del cambio. |
| Governance: toda enmienda indica las secciones afectadas. | QUÉ | idéntica | Es delimitación del cambio. |
| Governance: toda enmienda actualiza la versión. | QUÉ | idéntica | Es control de versiones documental. |
| Governance: toda enmienda actualiza la fecha de modificación. | QUÉ | idéntica | Es trazabilidad temporal. |
| Governance: toda enmienda se revisa frente a los principios aplicables. | QUÉ | idéntica | Es una regla de consistencia interna. |
| Governance: toda enmienda se revisa frente a las pruebas. | QUÉ | idéntica | Exige comprobar su efecto en la verificación. |
| Governance: la versión sigue SemVer. | QUÉ | idéntica | Es una convención portable de versionado, no una librería. |
| Governance: MAJOR al retirar o redefinir incompatiblemente un principio. | QUÉ | idéntica | La condición de cambio mayor sigue siendo válida. |
| Governance: MINOR al añadir un principio o sección o ampliar materialmente una regla. | QUÉ | idéntica | La condición de cambio menor sigue siendo válida. |
| Governance: PATCH para aclaraciones y cambios editoriales no semánticos. | QUÉ | idéntica | La condición de parche sigue siendo válida. |
| Governance: las revisiones verifican el cumplimiento de la constitución. | QUÉ | idéntica | Es una regla de gobernanza reusable. |

### Conteo de la Constitution

Se analizaron **44 reglas**: **34 idénticas**, **9 adaptadas en redacción** y **1 reemplazada**. Por tipo: **34 QUÉ**, **9 MIXTO** y **1 CÓMO**.

Estos conteos son independientes de la spec y no entran en su porcentaje CÓMO. La constitución sí tiene el propósito de fijar arquitectura y calidad; encontrar decisiones de implementación aquí no demuestra contaminación de la spec.

## 3. Pregunta 3: hallazgos y cambios pendientes

### ¿Es necesario modificar la spec para React?

No se identifican enunciados que deban cambiar **por usar React**. Las reglas de cálculo, entrada, errores, presentación, pruebas y ausencia de persistencia conservan su significado. No se debe cambiar «sin conexión» o «sin solicitudes de red» para acomodar una implementación: esa implementación deberá cumplir el contrato. La forma de disponer de la aplicación para usarla offline pertenece al diseño y debe distinguirse del cálculo una vez disponible; el documento no define el procedimiento de instalación o primera carga.

### Contradicción ya presente, independiente de React

**Enunciado exacto que habría que corregir, sin editarlo ahora:**

> **SC-001**: Los seis escenarios de aceptación proporcionados producen el importe o mensaje especificado en 6 de 6 ejecuciones.

La historia 1 tiene cuatro escenarios, la historia 2 tiene dos y la historia 3 tiene uno: **4 + 2 + 1 = 7**. SC-001 no identifica un subconjunto que justifique contar seis. Propuesta pendiente: «Los siete escenarios de aceptación proporcionados producen el resultado o mensaje especificado en 7 de 7 ejecuciones». «Resultado» también permite incluir expresamente el caso offline. Si se pretendía medir solo las primeras dos historias, debe declararse ese alcance y medir por separado la tercera.

`/speckit-analyze` podría señalar esta discrepancia al contrastar escenarios y criterios. No se ha ejecutado ese comando ni se afirma que haya emitido un hallazgo. El defecto es de consistencia y cobertura, no una decisión CÓMO.

**Precisión de redacción adicional:** FR-002 y FR-006 dicen «entero monetario siguiente», mientras Edge Cases y los supuestos establecen que un importe ya entero no aumenta. No exige un cambio por React: se deben leer juntos. Si se aclara posteriormente, sustituir ese fragmento por «menor entero monetario mayor o igual al importe» evita interpretar un incremento obligatorio para importes enteros.

### Cambios que sí exigiría una constitución para React

Las filas marcadas como adaptadas o reemplazadas identifican las reglas exactas afectadas: referencias a clases en SRP/OCP/DIP, raíz `lib/`, Dart puro, prohibición de `package:flutter`, composición en `main.dart`, elección de Flutter, null safety y control de `pubspec.yaml`. Deben trasladarse conservando los principios y documentando el cambio de tecnología. Los nombres de archivos propuestos y TypeScript son alternativas de redacción o implementación, no decisiones añadidas a la spec.

### Umbral del deber

La spec obtiene **0 % de decisiones CÓMO (0 de 106 enunciados)** y **0 enunciados MIXTOS**. No supera el 30 % y, bajo el criterio de este deber, **no está contaminada de decisiones técnicas**. La discrepancia de SC-001 se documenta como un hallazgo separado y no altera esa clasificación.

El **30 % es un umbral pedagógico de este deber, no una regla universal de SDD**. Los MIXTOS se informan por separado y no se suman al numerador CÓMO.
