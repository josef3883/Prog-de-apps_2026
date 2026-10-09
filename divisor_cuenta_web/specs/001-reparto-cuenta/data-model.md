# Data model: Reparto de cuenta

## Entrada textual y estado de pantalla

| Campo | Representación | Regla |
|---|---|---|
| monto | string | No negativo, punto o coma decimal, hasta dos decimales, sin miles. |
| personas | string | Entero positivo. |
| propina | string | De 0 a 100 inclusive, punto o coma, hasta dos decimales, sin miles. |
| modo | string | id perteneciente al catálogo inyectado; inicialmente exacto. |

El hook conserva entradas, modo, resultado nullable y error nullable mediante useState.
Los campos inician vacíos; no hay cálculo inicial. Las opciones vienen de main.

Decisión léxica de implementación: quitar espacios exteriores, exigir parte entera y,
si hay separador decimal, una o dos cifras posteriores. Se aceptan 0, 1, 1.2 y 1,20;
se rechazan .5, 1., 1e2, Infinity, NaN y agrupaciones. En monto/propina una única coma
o punto con hasta dos cifras posteriores se interpreta como decimal, no como miles.
Por ejemplo, 1,000 y 1.000 se rechazan por tres cifras; 1,00 se acepta como un decimal.
Personas admite signo opcional y dígitos, no separador decimal. Estas decisiones concretan
formatos no exhaustivamente especificados, sin cambiar límites de negocio.

## Cuenta válida: cuenta.js

Registro inmutable descrito con JSDoc, producido por validarEntrada:

| Campo | Tipo | Invariante |
|---|---|---|
| montoCentavos | bigint | >= 0 |
| personas | bigint | >= 1 |
| propinaCentesimas | bigint | Entre 0 y 10000 inclusive. |

No contiene texto de UI, modo concreto ni importaciones de framework. 10 % equivale a
1000n centésimas; 100 % a 10000n. El modo se resuelve fuera del cálculo y no forma
parte de la cuenta numérica. La solicitud de la spec reúne entrada textual y modo;
Cuenta representa su porción numérica validada.

## Valor de redondeo: estrategiaRedondeo.js

{ numerador: bigint, denominador: bigint } representa centavos racionales, no unidades
monetarias. numerador >= 0 y denominador > 0. No se convierte a Number para redondear.
Es un contrato estructural JSDoc; JavaScript no requiere una interfaz de TypeScript.

## Resultado: resultado.js

{ importeCentavos: bigint }, importeCentavos >= 0. Es una salida numérica independiente
 del DOM, del símbolo monetario y de la representación textual. El formateador genera
exactamente dos decimales; la pantalla añade «por persona».

## Validación y errores de entrada

validarEntrada recibe los tres strings y retorna una unión etiquetada:
{ ok: true, cuenta } o { ok: false, error: { campo, mensaje } }.

| Condición | Mensaje |
|---|---|
| Monto vacío, negativo, no numérico/no finito, agrupado o con más de dos decimales | Monto inválido |
| Personas enteras cero o negativas | Debe haber al menos una persona |
| Personas vacías, no numéricas, no finitas o no enteras | Número de personas inválido |
| Propina vacía, no numérica/no finita, agrupada, con más de dos decimales o fuera de 0..100 | Propina inválida |

Se devuelve el primer error en orden monto → personas → propina. Los errores esperables
de entrada no se lanzan como excepciones. El hook no llama al cálculo al fallar la validación.
El modo es una selección controlada del catálogo, no un campo numérico ni un tipo de estrategia.

## Transiciones

| Evento | Entradas | Resultado/error | Cálculo |
|---|---|---|---|
| Inicio | Vacías, modo exacto | Ambos null | Ninguno |
| Editar campo o modo | Actualizar estado | Ambos null | Ninguno |
| Calcular con entrada inválida | Conservar | resultado null; error específico | No invocar |
| Calcular con entrada válida | Conservar | resultado nuevo; error null | Una ejecución |
| Volver a calcular | Conservar | Sustituir salida previa | Una ejecución |

No existen relaciones persistentes ni serialización JSON; BigInt permanece en memoria.
Los registros son valores, no instancias de implementaciones de servicios. main es el
único lugar que compone estrategias concretas para producción.
