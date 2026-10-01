<!--
Sync Impact Report
Version: scaffold sin ratificar -> 1.0.0 (constitución inicial)
Modified principles: constitución inicial; definidos I. Calidad de código (SOLID), II. Arquitectura por capas, III. Seguridad, IV. Calidad y pruebas, V. Regla de la materia
Added sections: Restricciones del proyecto; Flujo de desarrollo y revisión
Removed sections: ninguna
Follow-up TODOs: fecha original de ratificación desconocida; completar al ratificar
-->
# División de Cuenta Constitution

## Core Principles

### I. Calidad de código (SOLID)
Cada clase DEBE tener una sola razón de cambio (SRP); el cálculo no valida ni formatea.
Agregar una regla de redondeo DEBE ser posible sin modificar las clases existentes (OCP).
Cualquier implementación de una interfaz DEBE poder sustituir a otra sin que quien la usa
compruebe su tipo (LSP). Las interfaces DEBEN ser pequeñas y sus consumidores no dependerán
de métodos que no usan (ISP). La presentación DEBE depender de abstracciones del dominio,
nunca de clases concretas de datos (DIP). Estas reglas mantienen los cambios localizados y
permiten sustituir políticas sin acoplar a sus consumidores.

### II. Arquitectura por capas
El código DEBE organizarse en `lib/presentation`, `lib/domain` y `lib/data`, con la dirección
de dependencias `presentation -> domain <- data`. `lib/domain/` DEBE ser Dart puro y no puede
importar `package:flutter`. `main.dart` es el único lugar donde se instancian implementaciones
concretas. Esto mantiene las reglas de negocio independientes del framework y de sus
adaptadores.

### III. Seguridad
Nunca se guardan secretos ni claves de API en el repositorio. Así se evita exponer
credenciales mediante el historial o la distribución del código.

### IV. Calidad y pruebas
Toda funcionalidad crítica DEBE tener pruebas ejecutables. Los criterios de aceptación de
cada spec DEBEN convertirse en pruebas ejecutables. Esto hace verificables los
comportamientos exigidos antes de dar por cumplida una funcionalidad.

### V. Regla de la materia
Toda función generada por el agente DEBE poder ser explicada por el estudiante: qué hace,
por qué existe, qué recibe, qué devuelve y qué errores produce. Esto mantiene el trabajo
alineado con el aprendizaje y permite revisar la lógica de forma consciente.

## Restricciones del proyecto
La aplicación es Flutter y consta de una sola pantalla. El código DEBE usar null safety y
nombres en español. No se añaden paquetes externos ni se modifica `pubspec.yaml` sin avisar
antes.

## Flujo de desarrollo y revisión
Antes de aceptar un cambio, la revisión DEBE comprobar los principios aplicables y que las
pruebas ejecutables cubran las funcionalidades críticas y los criterios de aceptación de
cada spec.

## Governance
Esta constitución rige las decisiones y revisiones del proyecto. Toda enmienda DEBE indicar
su motivo y las secciones afectadas, actualizar la versión y la fecha de modificación, y
revisarse frente a los principios aplicables y las pruebas.

La versión sigue SemVer: MAJOR para retirar o redefinir de forma incompatible un principio;
MINOR para añadir un principio o sección, o ampliar materialmente una regla; PATCH para
aclaraciones y cambios editoriales no semánticos. Las revisiones DEBEN verificar el
cumplimiento de esta constitución.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): fecha original desconocida | **Last Amended**: 2026-10-01
