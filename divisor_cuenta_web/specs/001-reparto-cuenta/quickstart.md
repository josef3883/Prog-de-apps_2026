# Quickstart de validación

El feature está implementado. Resultados y limitaciones observados:
[validacion.md](validacion.md). Este documento permite repetir sus comprobaciones.

## Prerrequisitos y preparación

- Node 24.20.0 disponible en el entorno inspeccionado y npm.
- Proyecto React/Vite existente; Vitest y jsdom están registrados en package-lock.json.
- Scripts: test = vitest; test:run = vitest run; dev/build/lint/preview se conservan.

Dependencias de pruebas incorporadas durante implementación:

```powershell
npm install -D vitest jsdom
```

Tras disponer del lockfile actualizado, instalación reproducible y comprobaciones:

```powershell
npm ci
npm run test:run
npm run lint
npm run build
npm run preview -- --host 127.0.0.1
```

En PowerShell puede usarse npm.cmd si npm.ps1 está bloqueado por la política de scripts.
La instalación necesita acceso al registro npm; la ejecución funcional posterior no.
Vitest utiliza Node para dominio/data/formato; las pruebas JSX de hook/pantalla seleccionan
jsdom. La configuración reutiliza el plugin React de vite.config.js. No añadir una
librería de estado ni una biblioteca adicional de utilidades de pruebas de UI.

## Resultados exigidos

1. Todas las pruebas de [aceptación](contracts/interfaz.md) y
   [contratos](contracts/modulos.md) pasan. Se cubren siete escenarios, pese a que SC-001
   menciona seis; no editar spec.md para ocultar la discrepancia.
2. Cada categoría inválida verifica el mensaje exacto y la ausencia de resultado anterior.
3. La salida de los cuatro primeros escenarios es 27.50, 30.00, 3.33 y 4.00 por persona.
4. Los empates, la propina antes del reparto, los enteros en modo hacia arriba y la coma
   decimal cumplen la matriz. Ninguna salida añade moneda ni cambia los dos decimales.
5. lint y build finalizan sin errores; el dominio no importa React/DOM/Vite y la
   presentación no importa data. La composición concreta productiva está solo en main.

## Comprobación en navegador

Abrir la URL que imprime preview, cargar la pantalla y comprobar campos y opciones.
Introducir los casos de aceptación, pulsar Calcular y verificar texto/ausencia de resultado.
Editar después de calcular: la salida se oculta y no aparece otra hasta volver a calcular.

Para SC-003, iniciar un cronómetro al pulsar Calcular y detenerlo cuando aparezca el
resultado; debe tardar menos de un segundo. Registrar navegador, dispositivo y medición.
La comprobación automática de actualización del DOM complementa esta medición explícita.
Vitest también verifica menos de 1000 ms hasta el resultado. Para repetir el cronómetro
real de navegador y la desconexión, con preview en el puerto 4173:

```powershell
npm.cmd install --prefix .qa-tools --no-save --package-lock=false playwright
node scripts/validar-navegador.mjs
```

Requiere Chrome instalado. Playwright es herramienta temporal aislada, no dependencia
de la aplicación. El harness mide desde clic hasta dos frames y verifica el texto;
guarda JSON y capturas en .qa-tools/. No es una medición humana manual.

Para offline, usar el build de preview, terminar de cargar sus recursos y abrir Network.
Activar Offline, limpiar el registro de solicitudes, completar una cuenta y calcular.
La salida debe ser correcta y no aparecer solicitudes nuevas. Repetir con ambos modos.
Comprobar que no se escriben datos de la cuenta en Local/Session Storage, IndexedDB ni cookies.
No usar el servidor de desarrollo con HMR como evidencia de cero tráfico funcional.

También puede mantenerse el servidor en loopback y desactivar Internet para verificar
que la aplicación se sirve y calcula sin acceso externo. Recargar una URL remota en modo
Offline es una prueba diferente de la definida aquí: no está garantizada sin caché o
service worker. No se afirma que Vite provea automáticamente esa capacidad.

## Verificación pedagógica

Para cada función generada, el estudiante explica propósito, motivo, entradas, salida y
 errores usando [los contratos](contracts/modulos.md) y un caso de prueba. Los errores
esperables de entrada retornan datos; el cálculo asume Cuenta válida. No se ocultan fallos
de programación bajo mensajes como Monto inválido.

## Estado

La implementación y las comprobaciones están registradas en validacion.md y tasks.md.
La spec se conserva intacta, incluida la discrepancia de SC-001. No se afirma comprensión
personal del estudiante: se proporcionan explicaciones y casos para su revisión.
