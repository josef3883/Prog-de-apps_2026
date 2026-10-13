# Respuestas

1. **Rojo antes de verde.**
   `flutter test` mostró: `Expected: 'La propina no puede superar el 100%'`, pero `Actual: 'Propina inválida'`. Ver la prueba fallar primero permite comprobar que detecta lo que falta y no pasa por casualidad. En este caso también descubrimos que la prueba usaba un mensaje fijo en su auxiliar; hubo que corregirla para comprobar el mensaje de producción.

2. **Linter vs. IA.**
   `flutter analyze` avisó que `variableSinUsar` no se utilizaba (`unused_local_variable`). La IA señaló el número mágico `10000` repetido. El linter detecta reglas automáticas concretas, pero no interpreta que ese número representa la misma escala de puntos básicos en dos archivos.

3. **Tu refactorización.**
   Elegimos el número mágico repetido. Creamos la constante compartida `puntosBasicosPorUnidad = 10000` y la usamos en validación y cálculo. El valor y las operaciones quedaron iguales, y las 38 pruebas pasaron. Eso respalda que el comportamiento se mantiene en los casos probados.

4. **Coverage.**
   Entre los archivos registrados, `lib/main.dart` tiene la cobertura más baja: 85,71 % (12 de 14 líneas). Eso no significa que tenga errores, sino que hay líneas que las pruebas no ejecutaron. La cobertura mide ejecución, no garantiza que el código sea correcto.
