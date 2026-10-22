# Modelo de datos: Reparto de cuenta

## `Cuenta`

Solicitud validada para un cálculo.

| Campo | Tipo conceptual | Restricciones |
|---|---|---|
| `montoCentimos` | Entero | No negativo; el texto de origen admite como máximo dos decimales. |
| `cantidadPersonas` | Entero | Mayor que cero. |
| `propinaPuntosBasicos` | Entero | De 0 a 10 000 inclusive; 100 puntos básicos equivalen a 1 %. |

`ValidarEntrada` convierte los campos de texto en una `Cuenta` o devuelve errores de validación identificables. El dominio no conoce widgets ni depende de Flutter.

`Cuenta` representa los valores numéricos de la **Solicitud de reparto** descrita en la
spec. El modo elegido forma parte de la solicitud de uso, pero se pasa por separado como
una `EstrategiaRedondeo` a `CalcularDivision`; no se almacena como un enum cerrado en
`Cuenta`.

## `EstrategiaRedondeo`

Abstracción de dominio con un único método conceptual:

`calcularParte(totalConPropinaCentimos, cantidadPersonas) -> importePorPersonaCentimos`

Recibe el total ya incrementado por la propina y el divisor. No valida entradas ni formatea la salida.

La estrategia elegida se pasa a `CalcularDivision` al calcular; `Cuenta` no depende de una
política de presentación.

## Selección de política

`DivisorController` recibe por constructor las opciones de redondeo: cada opción presenta una
etiqueta y una referencia a la abstracción `EstrategiaRedondeo`. La pantalla selecciona una
opción y el controller pasa su estrategia a `CalcularDivision`. El registro se compone en
`main.dart`, por lo que agregar una política no requiere editar clases existentes.

## `Resultado`

Resultado de una `Cuenta` válida.

| Campo | Tipo conceptual | Restricciones |
|---|---|---|
| `importePorPersonaCentimos` | Entero | No negativo; contiene el resultado de la estrategia elegida. |
| `propinaCentimos` | Entero | Importe de propina redondeado al centésimo más cercano, con empates hacia arriba. |
| `totalConPropinaCentimos` | Entero | `montoCentimos + propinaCentimos`. |

El resultado se mantiene en memoria durante el uso de la pantalla; no se persiste.

## Reglas de cálculo y redondeo

1. La propina se calcula sobre `montoCentimos`: `montoCentimos × propinaPuntosBasicos / 10 000`; el resultado se lleva a centésimos con empates hacia arriba.
2. `CalcularDivision` suma la propina y delega la parte por persona a la estrategia seleccionada.
3. `RedondeoExacto` devuelve el cociente monetario redondeado al centésimo más cercano; los empates se redondean hacia arriba.
4. `RedondeoHaciaArriba` devuelve el menor entero monetario que no sea inferior a la parte sin redondear. Si esta ya es entera, la conserva.
5. `FormateadorMoneda` representa el importe en dos decimales. El símbolo de moneda queda fuera del modelo porque no está especificado.

## Errores y estado de pantalla

- Monto vacío, negativo, no finito, no numérico o con más de dos decimales: error `montoInvalido`, mostrado como «Monto inválido»; se acepta punto o coma decimal, sin separadores de miles.
- Cero o menos personas: error `debeHaberUnaPersona`, mostrado como «Debe haber al menos una persona».
- Cantidad de personas no entera o no numérica: error `numeroPersonasInvalido`, mostrado como «Número de personas inválido».
- Propina no numérica, no finita, con separadores de miles, con más de dos decimales o fuera de 0–100 %: error `propinaInvalida`, mostrado como «Propina inválida»; se acepta punto o coma decimal.
- Una entrada inválida al calcular oculta cualquier resultado anterior.
- Cambiar los campos no calcula automáticamente; la acción «Calcular» procesa los valores actuales.
