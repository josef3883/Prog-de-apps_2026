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

- El monto vacío, negativo o no numérico se considera inválido; al tocar «Calcular» se muestra «Monto inválido» y no se muestra un resultado anterior como si correspondiera a la nueva entrada.
- La cantidad de personas debe ser un entero mayor o igual que uno. Cero muestra «Debe haber al menos una persona»; un valor no entero o no numérico muestra «Número de personas inválido».
- La propina debe ser un porcentaje numérico entre 0 y 100, inclusive; cualquier otro valor muestra «Propina inválida».
- Si el importe por persona ya es un número entero, el modo hacia arriba conserva ese importe y lo muestra con dos decimales.
- Al cambiar datos después de calcular, se requiere volver a tocar «Calcular» para obtener un resultado actualizado.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La app MUST permitir ingresar el monto total, la cantidad de personas y el porcentaje de propina en una sola pantalla.
- **FR-002**: La app MUST ofrecer los modos de redondeo exacto y hacia arriba al entero monetario siguiente.
- **FR-003**: La app MUST calcular únicamente cuando la persona toque «Calcular».
- **FR-004**: El cálculo MUST sumar al monto la propina porcentual y dividir el total entre la cantidad de personas.
- **FR-005**: En modo exacto, el importe por persona MUST mostrarse con dos decimales, redondeado al centésimo más cercano.
- **FR-006**: En modo hacia arriba, el importe por persona MUST redondearse hacia arriba al entero monetario siguiente y mostrarse con dos decimales.
- **FR-007**: Para cero personas, la app MUST mostrar «Debe haber al menos una persona» y no mostrar un resultado.
- **FR-008**: Para un monto no numérico como «abc», la app MUST mostrar «Monto inválido» y no mostrar un resultado.
- **FR-009**: Para una cantidad de personas no entera o no numérica, la app MUST mostrar «Número de personas inválido»; para una propina no numérica o fuera del rango de 0 a 100, MUST mostrar «Propina inválida». En ambos casos la app MUST ocultar cualquier resultado.
- **FR-010**: El cálculo MUST funcionar sin conexión, sin enviar solicitudes de red ni guardar la cuenta en una base de datos.

### Key Entities *(include if feature involves data)*

- **Solicitud de reparto**: total de la cuenta, número de personas, porcentaje de propina y modo de redondeo introducidos para un cálculo.
- **Resultado del reparto**: importe por persona calculado a partir de una solicitud válida y expresado con dos decimales.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Los seis escenarios de aceptación proporcionados producen el importe o mensaje especificado en 6 de 6 ejecuciones.
- **SC-002**: Para el 100 % de las entradas inválidas probadas, la app muestra el mensaje de error correspondiente y no presenta ningún resultado por persona.
- **SC-003**: En una medición con cronómetro, el importe por persona aparece antes de un segundo desde que se toca «Calcular» con datos válidos.
- **SC-004**: El 100 % de los resultados válidos identifica claramente el importe como «por persona» y lo muestra con exactamente dos decimales.

## Assumptions

- La propina se calcula sobre el monto total antes de dividirlo entre las personas.
- El modo exacto conserva la mayor precisión durante el cálculo y presenta el importe individual a dos decimales, redondeado al centésimo más cercano.
- El modo hacia arriba se aplica al importe final por persona después de añadir la propina y dividir; un importe ya entero no aumenta.
- Se aceptan montos no negativos y porcentajes de propina de 0 a 100 inclusive; personas debe ser un entero positivo.
- La cuenta solo se utiliza durante la sesión actual y no se persiste.
