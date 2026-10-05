# Tasks: Reparto de cuenta

**Input**: Design documents from `/specs/001-reparto-cuenta/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/ui.md`, `quickstart.md`

**Testing**: Se incluyen tareas de prueba porque la constitución exige pruebas ejecutables para cada criterio de aceptación. T002 es un requisito previo para cualquier tarea que escriba en `test/`; no modificar esos archivos sin autorización expresa.

**Organization**: Las tareas se agrupan por historia de usuario para permitir implementación y validación incremental.

## Format

Cada tarea usa `- [ ] Tnnn [P?] [USn?] descripción con ruta exacta`. `[P]` aparece solo cuando la tarea puede ejecutarse en paralelo sin competir por archivos; `[USn]` identifica las tareas de una historia.

## Phase 1: Setup

**Purpose**: Confirmar las dependencias actuales y resolver la autorización pendiente para los archivos de prueba.

- [X] T001 Ejecutar `flutter pub get` usando `pubspec.yaml` existente; no añadir paquetes ni modificar sus dependencias.
- [X] T002 Solicitar y registrar autorización expresa antes de reemplazar `test/widget_test.dart` o crear cualquier archivo bajo `test/`; no modificar tests sin aprobación. Autorización recibida el 2026-10-01.

---

## Phase 2: Foundational

**Purpose**: Crear los tipos y validación compartidos que bloquean las historias de usuario.

- [X] T003 [P] Crear `lib/domain/cuenta.dart` con `montoCentimos` no negativo, monto de origen con máximo dos decimales, `cantidadPersonas` mayor que cero y `propinaPuntosBasicos` de 0 a 10 000 inclusive (100 puntos básicos equivalen a 1 %).
- [X] T004 [P] Crear `lib/domain/resultado.dart` con importe individual no negativo, propina en centésimos redondeada con empates hacia arriba y total con propina igual a monto más propina.
- [X] T005 [P] Crear `lib/domain/estrategia_redondeo.dart` como abstracción Dart pura con un único método que recibe total con propina en centésimos y cantidad de personas, y devuelve el importe por persona en centésimos.
- [X] T006 Implementar `ValidarEntrada` en `lib/domain/validar_entrada.dart`: aceptar punto o coma decimal sin separadores de miles, rechazar montos no finitos o con más de dos decimales, exigir personas enteras positivas y propina de 0 a 100 % con hasta dos decimales; devolver errores identificables sin importar Flutter.

**Checkpoint**: Los tipos monetarios y la validación pueden usarse desde las historias sin introducir imports de Flutter en `lib/domain/`.

---

## Phase 3: User Story 1 - Calcular el reparto (Priority: P1) 🎯 MVP

**Goal**: Calcular y presentar el pago individual con propina en ambos modos.

**Independent Test**: Para 100.00/4/10 % exacto, 90.00/3/0 % exacto, 10.00/3/0 % exacto y 10.00/3/0 % hacia arriba, comprobar respectivamente 27.50, 30.00, 3.33 y 4.00 por persona.

### Tests for User Story 1

- [X] T007 [P] [US1] Añadir pruebas de dominio para los cuatro resultados válidos de la historia y los empates de medio centésimo en `test/domain/calcular_division_test.dart`; verificar que 0.01 entre 2 personas da 0.01 y que 1.00 con 0.5 % de propina da 1.01. Tests ejecutados en rojo antes de la implementación.
- [X] T008 [P] [US1] Reemplazar la prueba de contador por pruebas de la interacción válida para los cuatro casos de US1 en `test/widget_test.dart`; verificar la etiqueta «por persona», exactamente dos decimales, coma decimal y que el resultado aparece en menos de un segundo desde el toque en «Calcular». Test ejecutado en rojo antes de la implementación.

### Implementation for User Story 1

- [X] T009 [P] [US1] Implementar `RedondeoExacto` en `lib/data/redondeo_exacto.dart`: dividir el total con propina entre personas y redondear al centésimo más cercano, con empates hacia arriba.
- [X] T010 [P] [US1] Implementar `RedondeoHaciaArriba` en `lib/data/redondeo_hacia_arriba.dart`: devolver el menor entero monetario que no sea inferior a la parte individual y conservarla si ya es entera.
- [X] T011 [US1] Implementar `CalcularDivision` en `lib/domain/calcular_division.dart`: calcular la propina sobre el monto en centésimos con empates hacia arriba, sumarla y delegar el reparto a la `EstrategiaRedondeo` recibida.
- [X] T012 [P] [US1] Implementar `FormateadorMoneda` en `lib/presentation/formateador_moneda.dart` para presentar importes con exactamente dos decimales y sin asumir símbolo de moneda.
- [X] T013 [US1] Implementar `DivisorController` en `lib/presentation/divisor_controller.dart`, recibiendo `ValidarEntrada`, `CalcularDivision` y opciones etiquetadas de estrategias por constructor.
- [X] T014 [US1] Implementar `PantallaDivisor` en `lib/presentation/pantalla_divisor.dart` con campos de monto, personas y propina, selector de modo, acción «Calcular» y resultado «por persona»; actualizar el estado local con `setState`.
- [X] T015 [US1] Componer las estrategias concretas, validación, cálculo, formateador, controller y pantalla desde `lib/main.dart`, el único punto de composición.

**Checkpoint**: Los cuatro cálculos válidos de la spec funcionan en la pantalla con ambos modos y dos decimales.

---

## Phase 4: User Story 2 - Recibir errores de entrada (Priority: P2)

**Goal**: Mostrar los mensajes de validación especificados y no presentar resultados inválidos u obsoletos.

**Independent Test**: Con el reparto mostrado o sin él, calcular con cero personas y con monto `abc`; comprobar los mensajes exactos y que no aparece ningún resultado.

### Tests for User Story 2

- [X] T016 [P] [US2] Añadir pruebas de widget para cada categoría inválida de `spec.md` en `test/presentation/validacion_test.dart`: monto vacío, negativo, no finito, no numérico, con agrupadores o más de dos decimales; cero o menos personas, personas no enteras o no numéricas; propina no numérica, no finita, con agrupadores, con más de dos decimales o fuera de rango. Verificar mensaje exacto y ausencia de resultado. Tests ejecutados en rojo antes de T017/T018.

### Implementation for User Story 2

- [X] T017 [US2] Traducir los errores identificables de `ValidarEntrada` a los mensajes requeridos y limpiar cualquier resultado anterior en `lib/presentation/divisor_controller.dart`.
- [X] T018 [US2] Presentar los mensajes de validación y ocultar el resultado cuando el cálculo no sea válido en `lib/presentation/pantalla_divisor.dart`.

**Checkpoint**: Los errores «Debe haber al menos una persona» y «Monto inválido» aparecen exactamente y no dejan visible un resultado.

---

## Phase 5: User Story 3 - Calcular sin conexión (Priority: P3)

**Goal**: Confirmar que el flujo local funciona sin red ni almacenamiento externo.

**Independent Test**: Ejecutar un cálculo válido en el test de widget sin configurar servicios externos y repetir el flujo manual con el dispositivo sin conexión.

### Tests for User Story 3

- [X] T019 [P] [US3] Añadir una prueba de widget que construya la app y complete un reparto válido sin servicios externos en `test/presentation/offline_test.dart`; verificar la etiqueta «por persona» y exactamente dos decimales.

### Implementation and validation for User Story 3

- [X] T020 [US3] Verificar que la ruta de cálculo no usa red ni almacenamiento persistente y registrar el resultado de la comprobación offline en `specs/001-reparto-cuenta/quickstart.md`. Análisis estático sin referencias y test offline pasado; la desconexión manual queda como verificación de entrega.

**Checkpoint**: La app completa el cálculo local con conexión desactivada y conserva los resultados definidos en la spec.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verificar las restricciones arquitectónicas y completar la validación integral.

- [X] T021 [P] Revisar imports bajo `lib/domain/` y confirmar que ninguno usa `package:flutter`, según `lib/domain/`.
- [X] T022 [P] Revisar `pubspec.yaml` y `lib/` para confirmar que la feature no agrega paquetes, red ni almacenamiento.
- [X] T023 Ejecutar `flutter analyze` desde la raíz y resolver diagnósticos en `lib/` sin tocar `android/` ni `ios/`. Sin diagnósticos.
- [X] T024 Tras aprobación T002, ejecutar `flutter test` desde la raíz y verificar todos los escenarios de aceptación y casos límite en `test/`. Suite completa: 26/26 tests pasados.
- [ ] T025 Ejecutar los pasos manuales de `specs/001-reparto-cuenta/quickstart.md`, incluida la prueba offline, la etiqueta «por persona», los dos decimales y la medición menor de un segundo; anotar resultados.
- [ ] T026 Revisar cada función generada en `lib/domain/`, `lib/data/` y `lib/presentation/` con la sección «Revisión de comprensión» de `specs/001-reparto-cuenta/quickstart.md`; confirmar que el estudiante explica qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias. T002 solo bloquea las tareas que escriben en `test/`; no autoriza cambios por sí misma.
- **Foundational (Phase 2)**: Requiere T001; bloquea las historias. T003, T004 y T005 pueden ejecutarse en paralelo; T006 depende de T003.
- **User Stories (Phase 3+)**: Requieren Phase 2. Las tareas de prueba requieren además aprobación explícita de T002.
- **Polish (Phase 6)**: Requiere la implementación de las historias que se quieran aceptar. T024 no se completa sin T002 y ejecución exitosa de tests; T026 revisa las funciones antes de aceptar la implementación.

### User Story Dependencies

- **US1 (P1)**: Después de Phase 2 y T002 para sus pruebas. No depende de otra historia.
- **US2 (P2)**: Después de US1 porque amplía el controller y la misma pantalla. T016 depende de T002 y debe escribirse y fallar antes de T017 y T018.
- **US3 (P3)**: Después de US1 para probar el flujo completo. T019 requiere T002 y debe escribirse antes de validar el escenario; su archivo de prueba es independiente del de US2.

### Within Each User Story

- Crear primero las pruebas de la historia (una vez concedida T002), comprobar que fallan por ausencia del comportamiento y después implementar.
- En US1, crear las dos estrategias en paralelo; `CalcularDivision` depende de ambas y de los tipos del dominio.
- El controller depende de validación y cálculo; la pantalla depende del controller y del formateador; `main.dart` los conecta al final.
- En US2, T016 debe escribirse y fallar antes de modificar el controller y la pantalla; después, la traducción de errores precede a su presentación.
- En US3, T019 debe estar escrito antes de la comprobación offline; la validación manual espera a que la pantalla integrada esté lista.
- No declarar aceptación completa si la autorización para `test/` se deniega o si sus pruebas no se ejecutan correctamente.

### Parallel Opportunities

- **Phase 2**: T003, T004 y T005 usan archivos distintos y pueden ejecutarse en paralelo.
- **US1**: T007 y T008 pueden escribirse en archivos distintos en paralelo tras T002. Después, T009, T010 y T012 son independientes por archivo.
- **US2 y US3**: T016 y T019 usan archivos distintos y pueden escribirse en paralelo tras T002 y US1. Cada test debe fallar antes de implementar su comportamiento; T020 espera a que la pantalla integrada esté lista.

---

## Parallel Example: User Story 1

```text
Después de Phase 2 y de obtener aprobación T002:
- T007: pruebas de cálculo en test/domain/calcular_division_test.dart
- T008: prueba de interacción en test/widget_test.dart

Una vez escritos los tests:
- T009: lib/data/redondeo_exacto.dart
- T010: lib/data/redondeo_hacia_arriba.dart
- T012: lib/presentation/formateador_moneda.dart
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Completar Setup y Phase 2.
2. Obtener autorización T002 antes de tocar pruebas.
3. Completar US1 y ejecutar sus pruebas válidas.
4. Validar los cuatro resultados de US1 de forma independiente.
5. No marcar el MVP aceptado hasta que sus pruebas autorizadas pasen.

### Incremental Delivery

1. Añadir US1: cálculo exacto y hacia arriba.
2. Añadir US2: errores de entrada y ocultación del resultado inválido.
3. Añadir US3: comprobar el flujo offline y la ausencia de servicios externos.
4. Ejecutar `flutter analyze`, `flutter test` y los pasos de `quickstart.md`.

## Notes

- `[P]` identifica tareas sobre archivos distintos y sin dependencias pendientes.
- `[USn]` enlaza cada tarea con la historia de usuario de `spec.md`.
- Los tests son obligatorios por la constitución; T002 preserva la instrucción de no modificar `test/` sin autorización.
- No añadir paquetes, modificar `pubspec.yaml` ni tocar `android/` o `ios/` para esta feature.
- `tasks.md` genera las tareas de implementación; no reemplaza los documentos de diseño ni ejecuta cambios de código.
