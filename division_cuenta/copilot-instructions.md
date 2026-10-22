# Instrucciones del proyecto

Esta es una app Flutter de una sola pantalla para dividir una cuenta.

Organiza el código en `lib/presentation`, `lib/domain` y `lib/data`. Mantén la dependencia `presentation -> domain <- data`: presentación y datos pueden depender del dominio; el dominio no depende de esas capas ni importa `package:flutter`.

Usa null safety, nombres en español y solo dependencias ya existentes. No agregues paquetes externos ni modifiques `pubspec.yaml` sin avisar antes.

No modifiques `test/` sin que te lo pida. No toques `android/` ni `ios/`.

Comandos habituales: `flutter pub get`, `flutter run`, `flutter analyze` y `flutter test`.
