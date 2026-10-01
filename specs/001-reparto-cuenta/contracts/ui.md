# Contrato de interfaz: Divisor de cuenta

## Alcance

Una pantalla local para preparar y calcular un reparto. No expone APIs ni intercambia datos con servicios externos.

## Entrada

- **Monto total**: cantidad monetaria no negativa con hasta dos decimales. Se acepta punto o coma como separador decimal; no se aceptan separadores de miles.
- **Personas**: número entero positivo.
- **Propina**: porcentaje de 0 a 100 inclusive, con hasta dos decimales.
- **Modo**: exactamente una selección entre «Exacto» y «Hacia arriba».

## Acción

Al tocar «Calcular», se validan los campos actuales. Solo una entrada válida produce un resultado. Si la validación falla, se presenta el error correspondiente y se oculta cualquier resultado previo.

## Salida

- Resultado válido: importe que paga cada persona, identificado como «por persona» y con exactamente dos decimales.
- Monto inválido: «Monto inválido».
- Cero personas: «Debe haber al menos una persona».
- Cantidad de personas no entera o no numérica: «Número de personas inválido».
- Propina no numérica o fuera de rango: «Propina inválida».

El modo exacto redondea la parte individual al centésimo más cercano. El modo hacia arriba redondea esa parte al entero monetario siguiente; si ya es entera, no la incrementa.

## Ciclo y disponibilidad

Editar campos no recalcula por sí solo; la persona vuelve a tocar «Calcular» para procesar los nuevos valores. La interacción y el cálculo funcionan sin conexión y no guardan información después de la sesión.
