# Inventario de enunciados de la spec

Fuente: ../division_cuenta/analisis_spec.md, sección 1.
Una fila por obligación o escenario; repeticiones contadas en cada aparición.
Se excluyen títulos, metadatos y explicaciones sin obligaciones nuevas.

| Enunciado | Tipo | Portabilidad | Motivo |
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
