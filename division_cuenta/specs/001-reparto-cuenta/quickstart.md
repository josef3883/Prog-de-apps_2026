# Validación rápida: Reparto de cuenta

## Prerrequisitos

- Flutter 3.47.1 en canal stable (o Flutter stable compatible con Dart `^3.13.1`).
- El repositorio no requiere nuevas dependencias para esta funcionalidad.
- La prueba actual es la prueba de contador de la plantilla. Las instrucciones del proyecto prohíben modificar `test/` sin autorización expresa. Antes de añadir o reemplazar pruebas, solicitar permiso; no declarar cumplida la puerta de aceptación hasta ejecutar pruebas de la feature.

## Preparar y revisar

Desde la raíz del repositorio:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

`flutter pub get` usa las dependencias que ya declara `pubspec.yaml`; no añadir paquetes para este feature. `flutter analyze` no debe reportar errores. Tras la autorización para actualizar `test/`, `flutter test` debe cubrir los seis escenarios de aceptación de [spec.md](spec.md) y los casos límite de validación.

## Comprobación manual de la pantalla

1. Ejecutar `flutter run` y confirmar que se muestra una única pantalla con campos para monto, personas y propina, selector de modo y acción «Calcular».
2. Comprobar `100.00`, 4 personas, 10 % y «Exacto»: resultado `27.50` por persona.
3. Comprobar `90.00`, 3 personas, 0 % y «Exacto»: `30.00`.
4. Comprobar `10.00`, 3 personas, 0 %: «Exacto» muestra `3.33`; «Hacia arriba» muestra `4.00`.
5. Comprobar `50.00` y 0 personas: «Debe haber al menos una persona», sin resultado.
6. Comprobar monto `abc`: «Monto inválido», sin resultado.
7. Desactivar la conexión y repetir un cálculo válido; debe producir el mismo resultado sin servicio externo.
8. En todos los resultados válidos, comprobar que el importe está identificado como «por persona» y tiene exactamente dos decimales.
9. Medir desde el toque en «Calcular» hasta que aparece el resultado; debe tardar menos de un segundo.

## Revisión de comprensión

Antes de aceptar la implementación, el estudiante explica cada función generada en `lib/domain/`, `lib/data/` y `lib/presentation/`: qué hace, por qué existe, qué recibe, qué devuelve y qué errores produce. Si alguna función no se puede explicar, simplificarla o aclarar su contrato y repetir la revisión.

## Resultado de verificación offline

El análisis estático de `lib/` no encontró clientes de red, persistencia ni servicios externos. `test/presentation/offline_test.dart` pasó con un cálculo válido y sin servicios configurados. La comprobación manual con la conectividad del dispositivo desactivada queda pendiente de ejecutar en el entorno de entrega.
