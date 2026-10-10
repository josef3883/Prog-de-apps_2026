# Evidencia de comparación de specs

Fecha de comprobación: 2026-10-09. Feature activo: specs/001-reparto-cuenta,
resuelto desde .specify/feature.json porque la variable de entorno no estaba definida.

```powershell
git diff --no-index -- "..\division_cuenta\specs\001-reparto-cuenta\spec.md" `
  ".\specs\001-reparto-cuenta\spec.md"
```

```text
stdout: vacío (0 bytes)
stderr: vacío
código de salida: 0
```

| Archivo | Contenido |
|---|---|
| [diff-spec.txt](diff-spec.txt) | Salida estándar literal, vacía, de comparar las rutas reales. |
| [resultado.json](resultado.json) | Rutas absolutas, comandos, salidas, códigos, hashes y conteos. |
| [flutter-comparada.md](flutter-comparada.md) | Instantánea exacta del archivo Flutter comparado. |
| [react-comparada.md](react-comparada.md) | Instantánea exacta del archivo React comparado. |
| [react-primer-commit.md](react-primer-commit.md) | Blob inicial de React extraído de Git, sin reescritura. |
| [diff-primer-commit.txt](diff-primer-commit.txt) | Salida estándar literal, vacía, de comparar Flutter con el blob inicial. |
| [inventario-enunciados.md](inventario-enunciados.md) | Las 106 filas de la sección 1 del análisis Flutter, preservadas para justificar el porcentaje. |

Las dos instantáneas actuales tienen SHA-256
`2E7E20D862FFA432CD36479C5042803673903125FC6DE56B3D3709C09DBC3220`.
El blob de `219882fd743eb42c07e4e8fd6739f83f3f313bd5` tiene finales LF y SHA-256
`7DF2FA34A517F2AF6167AB5C1EBB068015EFD8689E5ACEBC099B2424AE15E56E`;
su texto es igual al actual normalizando LF/CRLF. Git diff también lo considera igual,
con código 0; su aviso de conversión de finales de línea se conserva en resultado.json.
No se afirma igualdad de bytes entre representaciones LF y CRLF.

La evidencia histórica se extrajo hoy del commit inicial; no se inventa una salida
capturada en el pasado. Ninguna spec original se modificó. Reutilización estimada:
106/106 enunciados = 100 %. No se detectó un bloqueo dependiente de Flutter que requiriera
adaptar la spec o crear un commit separado de corrección. Análisis completo:
[analisis_spec.md](../../../analisis_spec.md).
