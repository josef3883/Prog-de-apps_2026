<!--
Sync Impact Report
Version: scaffold sin ratificar -> 1.0.0 (constitución inicial)
Modified principles: definidos I. Calidad de código, II. Arquitectura, III. Seguridad,
IV. Calidad y pruebas, V. Regla de la materia.
Added sections: Alcance; Flujo de desarrollo y revisión; Governance.
Removed sections: ninguna regla vigente; retirados ejemplos del scaffold.
Follow-up TODOs: ninguno.
Informe temporal de revisión, no normativo. Comparación con Flutter: analisis_spec.md.
-->
# divisor_cuenta_web Constitution

## Core Principles

### I. Calidad de código (SOLID)

El código DEBE respetar SOLID:

- **SRP**: una función o módulo, una razón de cambio. El cálculo no valida ni formatea.
- **OCP**: agregar una nueva regla de redondeo no obliga a editar los módulos que ya existen.
- **LSP**: cualquier implementación de la interfaz de redondeo puede sustituir a otra
  sin que quien la usa pregunte de qué tipo es.
- **ISP**: interfaces pequeñas; nadie depende de funciones que no usa.
- **DIP**: `presentation` depende de abstracciones del `domain`, nunca de implementaciones
  concretas de `data`.

### II. Arquitectura

- Capas: `src/presentation` / `src/domain` / `src/data`.
- Regla de dependencia: `presentation -> domain <- data`.
- `src/domain/` NO importa `react` ni nada del DOM: es JavaScript puro.
- `src/main.jsx` es el ÚNICO lugar donde se instancian implementaciones concretas.

### III. Seguridad

Nunca guardar secretos ni API keys en el repositorio.

### IV. Calidad y pruebas

- Toda funcionalidad crítica DEBE tener pruebas.
- Los criterios de aceptación de la spec DEBEN convertirse en pruebas ejecutables.

### V. Regla de la materia

Toda función generada por el agente DEBE poder explicarla el estudiante: qué hace,
por qué existe, qué recibe, qué devuelve y qué errores produce.

## Alcance

Los cinco principios anteriores son los proporcionados por el usuario. No se incorporan
las restricciones adicionales de Flutter. La comparación en `analisis_spec.md` es
informativa y no añade requisitos.

## Flujo de desarrollo y revisión

Se conserva el flujo de revisión de Flutter: antes de aceptar un cambio, la revisión
DEBE comprobar los principios aplicables y que las pruebas cubran las funcionalidades
críticas y los criterios de aceptación de la spec.

## Governance

Se conserva la gobernanza documental de Flutter: esta constitución rige las decisiones
y revisiones del proyecto. Toda enmienda DEBE indicar su motivo y las secciones afectadas,
actualizar la versión y la fecha de modificación, y revisarse frente a los principios
aplicables y las pruebas.

La versión sigue SemVer: MAJOR para retirar o redefinir de forma incompatible un principio;
MINOR para añadir un principio o sección, o ampliar materialmente una regla; PATCH para
aclaraciones y cambios editoriales no semánticos. Las revisiones DEBEN verificar el
cumplimiento de esta constitución.

**Version**: 1.0.0 | **Ratified**: 2026-10-09 | **Last Amended**: 2026-10-09
