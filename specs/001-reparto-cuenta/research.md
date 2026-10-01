# Research: Reparto de cuenta

## Contexto

Flutter 3.47.1 en canal stable y Dart 3.13.1 están disponibles en el entorno. `pubspec.yaml` declara la restricción Dart `^3.13.1`, Flutter SDK, `cupertino_icons` y `flutter_lints`. El feature no necesita paquetes nuevos ni modifica esas declaraciones.

## Decisiones

### Capas y composición

- **Decisión**: Mantener `presentation -> domain <- data`. El dominio contiene entidades, validación, cálculo y la abstracción de redondeo; `data` contiene únicamente estrategias concretas; presentación coordina la pantalla y el estado local con `setState`.
- **Razón**: Sigue la constitución y las capas indicadas por el usuario, conserva el dominio como Dart puro y permite sustituir políticas de redondeo.
- **Alternativas consideradas**: Poner cálculo y validación en la pantalla o en un controller Flutter. Se descartan porque mezclan responsabilidades y acoplan el dominio a la UI.

### Inyección y estrategias de redondeo

- **Decisión**: `main.dart` crea `RedondeoExacto`, `RedondeoHaciaArriba`, validación, cálculo, formateador, controller y pantalla, y conecta sus dependencias. `DivisorController` recibe `ValidarEntrada`, `CalcularDivision` y la lista de opciones de redondeo por constructor. Cada opción de presentación contiene una etiqueta y una referencia `EstrategiaRedondeo`. `CalcularDivision` recibe la estrategia seleccionada al calcular y no pregunta por tipos concretos.
- **Razón**: `main.dart` es el único punto de composición, la presentación depende de la abstracción del dominio y agregar una política solo requiere implementarla y registrarla en `main.dart`; no obliga a editar clases existentes.
- **Alternativas consideradas**: Crear dependencias dentro del controller, mantener un enum/map cerrado de modos que haya que editar al añadir una opción, usar condicionales por clase concreta o hacer que el dominio importe implementaciones de `data`. Se descartan por violar inyección, OCP o la dirección de dependencias.

### Aritmética monetaria

- **Decisión**: Representar importes como unidades menores enteras (centésimos), y porcentajes con hasta dos decimales como puntos básicos enteros. Convertir el importe de propina al centésimo más cercano, con empates hacia arriba, antes de sumarlo y dividirlo. Las estrategias reciben el total con propina y la cantidad de personas, y devuelven la parte en centésimos: exacta al centésimo más cercano o hacia arriba al entero monetario siguiente.
- **Razón**: Evita que errores de coma flotante cambien los límites de redondeo. El orden de la estrategia reproduce el caso 10.00/3: 3.33 en exacto y 4.00 hacia arriba.
- **Alternativas consideradas**: Usar `double` de principio a fin o redondear solo en el formateador. Se descartan porque pueden alterar empates monetarios y mezclar presentación con reglas de negocio.

### Validación y formato

- **Decisión**: `ValidarEntrada` convierte texto de la UI a una `Cuenta` válida, acepta punto o coma como separador decimal, rechaza agrupadores y entradas no finitas, exige hasta dos decimales monetarios, personas enteras positivas y propina de 0 a 100 inclusive. Devuelve errores identificables que la presentación traduce a los mensajes de la spec. `FormateadorMoneda` presenta el importe con exactamente dos decimales, sin asumir símbolo de moneda.
- **Razón**: Mantiene la validación separada del cálculo y la traducción de mensajes fuera del dominio. La spec no fija moneda y sus ejemplos muestran importes sin símbolo.
- **Alternativas consideradas**: Añadir una dependencia de localización o asumir EUR/USD. Se descartan por la restricción de no añadir paquetes y por falta de una moneda definida.

### Contratos externos

- **Decisión**: No definir contratos de red, persistencia ni APIs. Documentar solo el contrato de interacción de la pantalla en `contracts/ui.md`.
- **Razón**: El cálculo es local y la spec prohíbe red y base de datos; la UI es la única frontera con el usuario.
- **Alternativas consideradas**: Crear un contrato de API o almacenamiento. Se descartan porque no existen esas integraciones en el alcance.

### Pruebas y autorización

- **Decisión**: Los seis escenarios de la spec y los casos límite son una puerta de aceptación obligatoria. No se modificarán archivos de `test/` sin autorización expresa; antes de implementarlos, solicitar permiso para reemplazar la prueba de contador de plantilla y añadir cobertura de la feature.
- **Razón**: La constitución exige pruebas ejecutables para los criterios de aceptación, mientras que las instrucciones del proyecto prohíben modificar `test/` sin petición. La prueba existente es del contador y no valida el reparto.
- **Alternativas consideradas**: Declarar la cobertura satisfecha con la prueba de plantilla o ignorar la constitución. Se descartan; hasta contar con permiso y ejecutar las pruebas, la puerta de aceptación no se declara superada.

## Aclaraciones

No quedan decisiones técnicas bloqueantes ni valores `NEEDS CLARIFICATION`. La moneda se mantiene sin símbolo porque la spec no la especifica; se usa formato numérico de dos decimales, como en sus escenarios.
