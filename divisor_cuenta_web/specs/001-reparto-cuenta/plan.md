# Implementation Plan: Reparto de cuenta

**Branch**: `001-reparto-cuenta` (identificador de Spec Kit; rama Git actual: `main`)
**Date**: 2026-10-09 | **Spec**: [spec.md](spec.md)

**Input**: `specs/001-reparto-cuenta/spec.md`, leída sin modificar.
La variable SPECIFY_FEATURE_DIRECTORY no estaba definida y no había feature.json.
Se seleccionó el único feature disponible y setup-plan lo registró como activo.

## Summary

Una pantalla React permite ingresar monto, personas y propina, seleccionar redondeo
exacto o hacia arriba y calcular únicamente mediante Calcular. JavaScript puro separa
validación, cálculo y estrategias; useState mantiene el estado local. main.jsx compone
las dependencias y las inyecta a la presentación. No hay backend ni persistencia.

La precisión se preserva con centavos BigInt y cocientes racionales. Vitest cubre dominio,
contratos y aceptación desde la pantalla. Esta fase genera diseño, no código ni tests.

## Technical Context

**Language/Version**: JavaScript ESM con JSX y BigInt nativo; Node instalado v24.20.0.
**Primary Dependencies**: React y react-dom ^19.2.8, Vite ^8.3.0 y plugin React ^6.1.1
según package.json; se conservan. Ninguna biblioteca de estado externa.
**Storage**: ninguno; tampoco localStorage, sessionStorage, IndexedDB ni cookies de cuenta.
**Testing**: Vitest; entorno Node para dominio/data/formato, jsdom para hook/pantalla.
React act y react-dom/client permiten probar la UI sin una biblioteca adicional de tests.
Vitest y jsdom serán dependencias de desarrollo, instaladas en implementación.
**Target Platform**: navegador moderno con soporte de BigInt; bundle estático de Vite.
**Project Type**: aplicación web de una pantalla, cálculo local síncrono.
**Performance Goals**: resultado visible antes de un segundo desde Calcular (SC-003).
**Constraints**: sin solicitudes de red durante el cálculo, sin base de datos, dominio
sin React/DOM, instanciación de implementaciones solamente en src/main.jsx.
**Scale/Scope**: una cuenta en memoria, dos políticas iniciales, tres campos y siete
escenarios de aceptación. No se añade un límite monetario ausente en la spec.

## Constitution Check

Puerta inicial: aprobada para el diseño propuesto. Revisión posterior a Fase 1: aprobada.
Estas comprobaciones son del diseño; no certifican el scaffold actual ni tests ejecutados.

| Principio | Evidencia de cumplimiento en el diseño |
|---|---|
| SRP | validarEntrada valida/normaliza; calcularDivision calcula; formateadorMoneda presenta. Los modelos describen datos. |
| OCP | main usa descubrimiento estático eager de módulos src/data/redondeo*.js; añadir un módulo con contrato y metadatos incorpora una opción sin editar módulos existentes. Hook y pantalla consumen un catálogo inyectado. |
| LSP | Todas las estrategias reciben el mismo racional y devuelven centavos BigInt; no hay instanceof ni comprobación de tipos concretos. |
| ISP | El contrato de estrategia solo exige aplicar(valor); id y etiqueta son metadatos del catálogo, no métodos del contrato. |
| DIP | La presentación recibe funciones y catálogo; no importa data. Data implementa el contrato del dominio. |
| Capas | presentation -> domain <- data; dominio sin dependencias de React, DOM o Vite. |
| Composición | Solo main descubre módulos, crea objetos de estrategias y enlaza cálculo, validación, formato y pantalla. |
| Seguridad | Ningún secreto, credencial ni servicio externo requerido. |
| Pruebas | Matriz de aceptación y casos críticos en contracts/interfaz.md; Vitest para todas las categorías inválidas. |
| Materia | Cada función tendrá contrato de propósito, entradas, salida y errores, con pruebas que el estudiante pueda explicar. |

El descubrimiento mediante import.meta.glob se limita a main y se resuelve en build:
no es descarga remota, plugin runtime ni dependencia de Vite dentro del dominio.
Las pruebas usan dobles y funciones exportadas; no crean instancias de implementaciones
productivas fuera de main. Los registros de cuenta/resultado son datos, no servicios DI.

## Project Structure

### Documentation (this feature)

```text
specs/001-reparto-cuenta/
  spec.md                       # original, sin cambios
  plan.md
  research.md
  data-model.md
  contracts/
    modulos.md
    interfaz.md
  quickstart.md
```

tasks.md corresponde a /speckit-tasks y no se genera en esta fase.

### Source Code (repository root)

Estructura prevista, todavía no implementada:

```text
src/
  domain/
    cuenta.js
    resultado.js
    calcularDivision.js
    validarEntrada.js
    estrategiaRedondeo.js
  data/
    redondeoExacto.js
    redondeoHaciaArriba.js
  presentation/
    useDivisor.js
    formateadorMoneda.js
    PantallaDivisor.jsx
  main.jsx
  index.css
tests/
  domain/
  data/
  presentation/
  contracts/
vite.config.js
package.json
```

**Structure Decision**: se usan exactamente los módulos solicitados. El scaffold App.jsx
se reemplazará como entrada visual por PantallaDivisor, sin introducir una cuarta capa.
La configuración de test se integra en vite.config.js; test en package.json será vitest
y test:run será vitest run. No se modifican estos archivos durante planificación.

## Diseño y secuencia de implementación

1. Definir modelos y contrato documentados con JSDoc en JavaScript, sin clases obligatorias.
2. Implementar validación léxica y normalización BigInt; verificar límites y mensajes.
3. Implementar cálculo y dos funciones aplicar; comprobar mitades, enteros y precisión.
4. Implementar formato independiente, hook con dependencias recibidas y pantalla controlada.
5. Componer exclusivamente en main, descubriendo las estrategias eager y ordenando opciones
   por metadatos; incorporar Vitest/jsdom y scripts en la fase de implementación.
6. Ejecutar aceptación, contratos, lint, build y validación offline/tiempo en navegador.

El hook recibe { validarEntrada, calcularDivision, formatearMoneda, modos }, donde cada
modo tiene id, etiqueta, orden y estrategia. Selecciona por id, nunca por tipo concreto.
La pantalla recibe este conjunto desde main y lo pasa al hook; genera opciones del catálogo.
No hay efectos que calculen automáticamente ni estado global.

## Discrepancias y decisiones explícitas

- SC-001 cuenta seis, pero las historias contienen siete escenarios. Se cubren los siete;
  no se corrige spec.md ni se reduce cobertura para coincidir con el número erróneo.
- «Entero siguiente» se interpreta según Edge Cases y Assumptions: menor entero mayor
  o igual al importe; un importe entero no aumenta.
- Primero se redondea la propina al centavo con mitades hacia arriba, como exige Assumptions.
- La gramática concreta, prioridad de errores y ocultación al editar son decisiones de
  diseño documentadas en data-model.md, no nuevos requisitos de negocio.
- Offline se valida con recursos ya cargados, o con servidor local disponible sin Internet.
  La spec no define instalación ni primera carga offline. Este plan no garantiza apertura
  o recarga de una URL remota desconectada y no presupone una PWA/service worker.

## Complexity Tracking

Sin violaciones constitucionales ni excepciones solicitadas. BigInt/racionales evitan
introducir límites monetarios o errores de coma flotante. El glob eager evita modificar
main para cada nuevo modo y cumple la redacción literal de OCP.
