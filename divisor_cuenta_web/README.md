# Divisor de cuenta

Aplicación React + Vite de una pantalla para repartir una cuenta con propina. JavaScript,
estado local con useState y cálculo decimal exacto mediante BigInt. Sin librerías de estado,
servicios externos ni persistencia de la cuenta.

## Ejecutar

Requiere Node compatible con las versiones del lockfile (validado con Node 24.20.0).

```powershell
npm.cmd ci
npm.cmd run dev
```

En PowerShell se usa npm.cmd para evitar el bloqueo de npm.ps1 por la política de scripts.
En otras terminales puede usarse npm directamente.

```powershell
npm.cmd run test:run
npm.cmd run lint
npm.cmd run build
npm.cmd run preview -- --host 127.0.0.1
```

## Uso

Ingresar monto total, número de personas y propina, elegir el redondeo y pulsar Calcular.
Monto y propina admiten punto o coma con hasta dos decimales; no admiten separadores de
miles. Personas debe ser un entero positivo; propina está entre 0 y 100 inclusive.
Exacto redondea al centavo con mitades hacia arriba; Hacia arriba al entero monetario
mayor o igual, conservando los enteros. La propina se redondea al centavo antes de repartir.
La salida siempre tiene dos decimales, sin símbolo monetario. Editar oculta la salida;
se requiere volver a pulsar Calcular. Los errores se muestran junto al campo correspondiente.

## Arquitectura

- src/domain: contratos, validación y cálculo; JavaScript puro, sin React ni DOM.
- src/data: funciones de redondeo que implementan aplicar(valor).
- src/presentation: hook con dependencias recibidas, formateador y pantalla.
- src/main.jsx: único punto de composición. Descubre estrategias eager durante el build.

Para añadir una política, crear src/data/redondeoNombre.js que exporte aplicar, id único,
etiqueta y orden. aplicar recibe { numerador, denominador } en centavos racionales BigInt
y devuelve centavos enteros BigInt. No se editan módulos consumidores ni main.

## Offline y validación

El cálculo funciona sin conexión una vez cargados los recursos. No hay solicitudes ni
almacenamiento de la cuenta. Abrir o recargar una URL remota desconectada no está garantizado:
no se implementó service worker ni caché de instalación.

Las 136 pruebas con Vitest cubren cálculo, contratos, entradas inválidas, UI, arquitectura,
extensión y ausencia de red/persistencia. La comprobación real en Chrome headless y su
cronómetro se documentan en [validacion.md](specs/001-reparto-cuenta/validacion.md).

Para repetir la comprobación de navegador (herramienta opcional, fuera de package.json),
con preview escuchando en 127.0.0.1:4173:

```powershell
npm.cmd install --prefix .qa-tools --no-save --package-lock=false playwright
node scripts/validar-navegador.mjs
```

Requiere Google Chrome instalado. La herramienta escribe capturas y resultados en
.qa-tools/, ignorado por Git; no añade Playwright a las dependencias de la aplicación.

Spec y constitución permanecen intactas. SC-001 dice seis escenarios, pero se cubren los
siete enumerados. Para personas negativas fraccionarias se prioriza FR-009 y se muestra
«Debe haber al menos una persona»; la decisión está registrada en la validación.
