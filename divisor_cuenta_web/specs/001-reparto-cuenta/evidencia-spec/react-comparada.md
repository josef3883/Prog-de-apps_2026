# Feature Specification: Reparto de cuenta

**Feature Branch**: `001-reparto-cuenta`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar Calcular ve cuánto paga cada persona con dos decimales. Puede elegir entre modo exacto y redondeo hacia arriba al entero más cercano. Funciona sin conexión, sin red ni base de datos."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Calcular el reparto (Priority: P1)

Como persona que paga una cuenta compartida, quiero introducir el total, el número de personas y la propina, elegir cómo redondear y calcular la parte individual para saber cuánto debe pagar cada persona.

**Why this priority**: El cálculo del importe por persona es el valor principal de la app.

**Independent Test**: Introducir datos válidos, seleccionar cualquiera de los modos y tocar «Calcular»; comprobar que aparece el importe por persona con dos decimales.

**Acceptance Scenarios**:

1. **Given** un total de 100.00, 4 personas y una propina del 10 %, **When** se elige el modo exacto y se toca «Calcular», **Then** se muestra 27.50 por persona.
2. **Given** un total de 90.00, 3 personas y una propina del 0 %, **When** se elige el modo exacto y se toca «Calcular», **Then** se muestra 30.00 por persona.
3. **Given** un total de 10.00, 3 personas y una propina del 0 %, **When** se elige el modo exacto y se toca «Calcular», **Then** se muestra 3.33 por persona.
4. **Given** un total de 10.00, 3 personas y una propina del 0 %, **When** se elige el modo hacia arriba y se toca «Calcular», **Then** se muestra 4.00 por persona.

---

### User Story 2 - Recibir errores de entrada (Priority: P2)

Como persona que está completando la cuenta, quiero recibir un mensaje claro si un dato no permite calcular el reparto, para poder corregirlo sin confundirlo con un resultado válido.

**Why this priority**: La validación evita mostrar importes engañosos cuando faltan datos o son inválidos.

**Independent Test**: Calcular con cero personas y con texto no numérico en el monto; comprobar el mensaje correspondiente y que no aparece ningún resultado.

**Acceptance Scenarios**:

1. **Given** un total de 50.00 y 0 personas, **When** se toca «Calcular», **Then** se muestra «Debe haber al menos una persona» y no se muestra ningún resultado.
2. **Given** que el campo de monto contiene «abc», **When** se toca «Calcular», **Then** se muestra «Monto inválido» y no se muestra ningún resultado.

---

### User Story 3 - Calcular sin conexión (Priority: P3)

Como persona que usa la app, quiero calcular la cuenta sin conexión para poder repartirla sin depender de un servicio externo.

**Why this priority**: El funcionamiento local garantiza que el cálculo esté disponible cuando no haya internet.

**Independent Test**: Desactivar la conexión, introducir datos válidos, calcular y comprobar el importe por persona.

**Acceptance Scenarios**:

1. **Given** que el dispositivo no tiene conexión, **When** se completa y calcula un reparto válido, **Then** la app muestra el resultado sin solicitar acceso a red ni a servicios de almacenamiento externos.

### Edge Cases

- El monto acepta punto o coma como separador decimal, no admite separadores de miles y puede tener hasta dos decimales. Si está vacío, es negativo, no numérico, no finito o excede dos decimales, al tocar «Calcular» se muestra «Monto inválido» y no queda visible un resultado anterior.
- La cantidad de personas debe ser un entero positivo. Cero o un valor negativo muestra «Debe haber al menos una persona»; un valor no entero o no numérico muestra «Número de personas inválido».
- La propina acepta punto o coma como separador decimal, no admite separadores de miles y debe ser numérica, finita, de 0 a 100 inclusive y tener hasta dos decimales. Si no cumple estas condiciones, se muestra «Propina inválida» y no queda visible ningún resultado.
- Si el importe por persona ya es un número entero, el modo hacia arriba conserva ese importe y lo muestra con dos decimales.
- Al cambiar datos después de calcular, se requiere volver a tocar «Calcular» para obtener un resultado actualizado.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La app MUST permitir ingresar el monto total, la cantidad de personas y el porcentaje de propina en una sola pantalla.
- **FR-002**: La app MUST ofrecer los modos de redondeo exacto y hacia arriba al entero monetario siguiente.
- **FR-003**: La app MUST calcular únicamente cuando la persona toque «Calcular».
- **FR-004**: El cálculo MUST sumar al monto la propina porcentual y dividir el total entre la cantidad de personas.
- **FR-005**: En modo exacto, el importe por persona MUST mostrarse con dos decimales, redondeado al centésimo más cercano; si queda exactamente a mitad entre centésimos, MUST redondearse hacia arriba.
- **FR-006**: En modo hacia arriba, el importe por persona MUST redondearse hacia arriba al entero monetario siguiente y mostrarse con dos decimales.
- **FR-007**: Para cero personas, la app MUST mostrar «Debe haber al menos una persona» y no mostrar un resultado.
- **FR-008**: Para un monto vacío, negativo, no finito, no numérico como «abc», con separadores de miles o con más de dos decimales, la app MUST mostrar «Monto inválido» y ocultar cualquier resultado.
- **FR-009**: Para cero o menos personas, la app MUST mostrar «Debe haber al menos una persona»; para una cantidad no entera o no numérica, MUST mostrar «Número de personas inválido». Para una propina no numérica, no finita, con separadores de miles, con más de dos decimales o fuera del rango de 0 a 100, MUST mostrar «Propina inválida». En todos los casos la app MUST ocultar cualquier resultado.
- **FR-010**: El cálculo MUST funcionar sin conexión, sin enviar solicitudes de red ni guardar la cuenta en una base de datos.
- **FR-011**: El monto y la propina MUST aceptar punto o coma como separador decimal, con hasta dos cifras decimales, y MUST rechazar separadores de miles.

### Key Entities *(include if feature involves data)*

- **Solicitud de reparto**: total de la cuenta, número de personas, porcentaje de propina y modo de redondeo introducidos para un cálculo.
- **Resultado del reparto**: importe por persona calculado a partir de una solicitud válida y expresado con dos decimales.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Los seis escenarios de aceptación proporcionados producen el importe o mensaje especificado en 6 de 6 ejecuciones.
- **SC-002**: El 100 % de las categorías de entrada inválida enumeradas en Edge Cases tiene al menos una prueba ejecutable que verifica el mensaje correspondiente y la ausencia de resultado.
- **SC-003**: En una medición con cronómetro, el importe por persona aparece antes de un segundo desde que se toca «Calcular» con datos válidos.
- **SC-004**: El 100 % de los resultados válidos identifica claramente el importe como «por persona» y lo muestra con exactamente dos decimales.

## Assumptions

- La propina se calcula sobre el monto total antes de dividirlo entre las personas.
- Los montos y porcentajes admiten punto o coma decimal y hasta dos decimales; no se admiten separadores de miles.
- El importe de propina se redondea al centésimo más cercano, con empates hacia arriba. El modo exacto conserva la mayor precisión del reparto y presenta el importe individual al centésimo más cercano, también con empates hacia arriba.
- El modo hacia arriba se aplica al importe final por persona después de añadir la propina y dividir; un importe ya entero no aumenta.
- No se fija una moneda ni se muestra un símbolo; el importe se presenta como un número con dos decimales.
- Se aceptan montos no negativos y porcentajes de propina de 0 a 100 inclusive; personas debe ser un entero positivo.
- La cuenta solo se utiliza durante la sesión actual y no se persiste.
