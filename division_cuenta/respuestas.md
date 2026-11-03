# Respuestas: CI y entrega del APK

## 1. Workflow y comandos

Archivo `.github/workflows/ci.yml`, ubicado en la raíz del repositorio:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  flutter:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: division_cuenta
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug

  entrega:
    needs: flutter
    if: ${{ github.event_name == 'push' && github.ref == 'refs/heads/main' }}
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: division_cuenta
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter build apk --debug
      - uses: actions/upload-artifact@v4
        with:
          name: app-debug
          path: division_cuenta/build/app/outputs/flutter-apk/app-debug.apk
          if-no-files-found: error
```

- `flutter analyze`: revisa el código y detecta errores, y problemas de estilo sin ejecutar la app.
- `flutter test`: ejecuta las pruebas y compara los resultados reales con los esperados.
- `flutter build apk --debug`: compila y genera un APK de depuración para Android.

## 2. Fallo de la Parte 3

Esta en (evidencias/parte3_rojo.png)

La línea 24 identificó la prueba: `division_cuenta/test/division_test.dart: 1. reparto normal (failed)`. La línea 67 y la 68 cornfimaron el error: `Error: 37 tests passed, 1 failed.` 

## 3. CI, continuous delivery y continuous deployment

CI verifica automáticamente los cambios con análisis, pruebas y compilación. Continuous delivery deja un resultado listo para entregar, con un paso manual para publicarlo. Continuous deployment también lo publica automáticamente en producción. Implementé CI y una entrega básica como artefacto descargable; no hay despliegue automático a ningún servicio.

## 4. Merge bloqueado

Esta en (evidencias/parte3_merge_bloqueado.png)

La protección exige que pase `CI / flutter` antes de fusionar. Así evita que lleguen a `main` cambios que fallan las verificaciones configuradas; no garantiza que la app no tenga otros errores.

## 5. Revisión del agente

Sugirió limitar permisos, desactivar las credenciales persistentes del checkout, fijar las actions por SHA, controlar las versiones del entorno, reutilizar el APK verificado y limitar tiempos y ejecuciones repetidas. 

## 6. Alcance de un CI verde

Significa que los pasos configurados pasaron para ese commit en ese entorno. Puede dejar fuera casos sin pruebas, problemas visuales o fallos en dispositivos reales. Por ejemplo, un botón podría quedar cortado en una pantalla pequeña y el CI seguir verde si ninguna prueba revisa ese tamaño.

## 7. Qué detectó el pipeline

Detectó que el reparto normal devolvía `27.50` mientras la prueba esperaba `27.00`, aunque el análisis del código pasaba. Era el fallo intencional del ejercicio, no un error nuevo descubierto en la app. También comprobé que GitHub solo prueba los cambios subidos: el primer commit llevó capturas, pero todavía no incluía la prueba modificada.


