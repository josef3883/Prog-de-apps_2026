# Implementation Plan: Reparto de cuenta

**Branch**: `001-reparto-cuenta` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Reparto local de una cuenta con propina y políticas de redondeo intercambiables.

## Summary

Reemplazar la pantalla contador de plantilla por un divisor de cuenta de una sola pantalla.
La presentación coordina validación y cálculo mediante dependencias inyectadas; el dominio
permanece en Dart puro y `main.dart` es el único punto de composición. Los importes se
representan en centésimos enteros; las estrategias exacto y hacia arriba deciden la parte
individual. No se añade red, persistencia ni dependencia externa.

## Technical Context

**Language/Version**: Dart 3.13.1; Flutter 3.47.1 en canal stable.

**Primary Dependencies**: Flutter SDK y Dart core. No se añaden paquetes; las dependencias
existentes de `pubspec.yaml` se conservan sin cambios.

**Storage**: Ninguno. Estado transitorio de una sola pantalla; sin red ni base de datos.

**Testing**: `flutter_test` existente. Los seis escenarios y los límites de validación deben
tener pruebas ejecutables. El test actual es el contador de plantilla; las instrucciones del
proyecto requieren autorización expresa antes de modificar `test/`. La puerta de aceptación
de implementación queda pendiente hasta obtenerla y ejecutar la cobertura de esta feature.

**Target Platform**: Targets Flutter ya configurados en el repositorio; sin cambios de
configuración de plataforma.

**Project Type**: Aplicación Flutter de una sola pantalla.

**Performance Goals**: Mostrar el resultado en menos de un segundo desde «Calcular», según
el criterio SC-003 de la spec.

**Constraints**: Null safety; nombres en español; estado local con `setState`; dependencias
`presentation -> domain <- data`; dominio sin `package:flutter`; implementaciones concretas
instanciadas en `main.dart`; sin paquetes nuevos, red, persistencia ni cambios a `android/`
o `ios/`.

**Scale/Scope**: Un reparto por vez con monto, personas, propina y uno de dos modos. Incluye
los seis casos de aceptación, errores de entrada y operación sin conexión.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Fase previa a diseño**: PASS. La estructura por capas respeta SRP/DIP y permite OCP con
`EstrategiaRedondeo`; `domain/` no importa Flutter y `main.dart` compone las implementaciones.
No hay secretos, servicios externos ni almacenamiento.

**Pruebas**: La constitución exige pruebas ejecutables para todos los criterios de aceptación.
El plan las conserva como puerta obligatoria, pero no modifica `test/` en esta fase. Antes de
implementar o reemplazar pruebas se solicitará autorización expresa, conforme a las
instrucciones del proyecto. No se declarará superada esta puerta hasta ejecutar las pruebas
de la feature.

**Regla de la materia**: PASS. El diseño separa y documenta las responsabilidades para que
cada función generada pueda explicarse.

**Revisión posterior al diseño**: PASS para arquitectura y seguridad. La puerta de pruebas
sigue pendiente de autorización y ejecución antes de aceptar la implementación.

## Project Structure

### Documentation (this feature)

```text
specs/001-reparto-cuenta/
├── plan.md              # Plan de implementación
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── ui.md
└── tasks.md             # Se generará después con /speckit-tasks
```

### Source Code (repository root)
```text
lib/
├── main.dart                         # Punto de composición; conecta dependencias
├── domain/
│   ├── cuenta.dart
│   ├── resultado.dart
│   ├── estrategia_redondeo.dart      # Contrato de un método
│   ├── validar_entrada.dart
│   └── calcular_division.dart
├── data/
│   ├── redondeo_exacto.dart
│   └── redondeo_hacia_arriba.dart
└── presentation/
    ├── divisor_controller.dart       # Dependencias por constructor; coordina el flujo
    ├── formateador_moneda.dart
    └── pantalla_divisor.dart         # Estado local con setState
```

**Structure Decision**: Mantener un solo paquete Flutter existente y crear las tres capas
debajo de `lib/`, respetando `presentation -> domain <- data`. `EstrategiaRedondeo` vive en
`domain/`; las dos políticas concretas viven en `data/`. `DivisorController` recibe
`ValidarEntrada`, `CalcularDivision` y opciones etiquetadas de `EstrategiaRedondeo` en el
constructor. La estrategia seleccionada se pasa a `CalcularDivision`; `main.dart` instancia
y registra implementaciones sin un enum cerrado ni condicionales por tipo. `PantallaDivisor`
mantiene los valores temporales con `setState`; no hay repositorios ni adaptadores de
almacenamiento.
