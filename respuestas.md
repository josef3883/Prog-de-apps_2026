# Deber 5: MCP Detective

## Arquitectura

El LLM interpretó la solicitud, eligió las herramientas y preparó sus argumentos; no ejecutó Python. El harness/host (Copilot en VS Code) conectó el modelo con las herramientas MCP. El cliente MCP envió las llamadas y recibió sus resultados. El servidor `mcp-detective` implementó las herramientas y ejecutó la lógica en el proceso Python iniciado por el host. Por tanto, Python lo ejecutó el servidor MCP, no el LLM ni el cliente.

## Evidencia

`listar_casos` devolvió INC-003 en `panel_administracion` con 5 eventos. `consultar_eventos` devolvió cuatro `LOGIN_FAILED` de `admin` desde `192.0.2.50`, entre 03:00 y 03:03, y un `LOGIN_SUCCESS` desde esa IP a las 03:04. Esa secuencia justifica investigar, pero los eventos no identifican quién inició sesión ni demuestran que el acceso fuera no autorizado; no permiten confirmar una intrusión.

`registrar_alerta` devolvió estado `registrada`, nivel `medio`. Aclaración: el motivo enviado decía “cinco intentos” aunque los resultados muestran cuatro fallos; esa discrepancia fue un error en el texto del motivo, no un quinto evento.

## Validación y seguridad

`consultar_eventos` para INC-999 devolvió el error “El caso 'INC-999' no existe.” El servidor MCP rechaza ese identificador y también valida el nivel permitido, el motivo no vacío y las alertas duplicadas. El cliente y el host pueden validar el formato del protocolo, pero no sustituyen esas reglas del servidor. No es seguro confiar solo en argumentos generados por el modelo: pueden ser incorrectos, incompletos o manipulados, así que el servidor debe validar cada llamada antes de actuar.

## Agente y conexión

Usé el agente Copilot en VS Code con las herramientas MCP de `mcp-detective`: `listar_casos`, `consultar_eventos` y `registrar_alerta`. Comprobé la conexión al descubrir las herramientas disponibles y al obtener resultados del servidor (incluido el error de caso inexistente); el Inspector también muestra el servidor conectado y las tres herramientas.

## Instalación y conexión con MCP Inspector

1. Instala Python, `uv` y Node.js/npm.
2. Desde la raíz del repositorio, inicia el Inspector: `npx -y @modelcontextprotocol/inspector`.
3. En el Inspector, agrega un servidor de tipo **STDIO** con comando `uv` y estos argumentos: `run --directory <ruta-absoluta-a-mcp-detective> --with mcp==2.3.0 python server.py`.
4. Pulsa **Connect**; al conectar, el Inspector debe mostrar las herramientas `listar_casos`, `consultar_eventos` y `registrar_alerta`.

No se necesitan tokens ni contraseñas para este servidor local por STDIO.
