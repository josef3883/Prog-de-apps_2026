# Contratos de módulos

Contratos previstos, no implementación. Tipos y representaciones: [data-model.md](../data-model.md).
El estudiante debe explicar propósito, entradas, salida y errores de cada función generada.
Las precondiciones de las funciones internas son garantías del flujo validado; el cálculo
no contiene validación redundante ni transforma texto inválido en errores de presentación.

| Módulo | Contrato y propósito | Errores |
|---|---|---|
| domain/cuenta.js | Describe Cuenta con JSDoc: montoCentavos, personas, propinaCentesimas. No servicio ni validador. | No ejecuta operaciones que fallen. |
| domain/resultado.js | Describe Resultado con importeCentavos. No convierte números a texto. | No ejecuta operaciones que fallen. |
| domain/validarEntrada.js | validarEntrada({ monto, personas, propina }) devuelve unión ok/cuenta o error/campo/mensaje; valida y normaliza. | Errores esperables como datos, no excepciones. |
| domain/estrategiaRedondeo.js | Contrato EstrategiaRedondeo: aplicar(valor) recibe racional de centavos válido y devuelve bigint de centavos >=0. Función pura, determinista, síncrona. | No falla para valores del contrato. Fuera del contrato, error de programación sin mensaje de validación pública. |
| domain/calcularDivision.js | calcularDivision(cuenta, estrategia) recibe Cuenta válida, calcula propina redondeada al centavo, suma/divide y llama estrategia.aplicar una vez para obtener Resultado. | No errores de usuario con precondiciones cumplidas. No captura ni oculta fallos de dependencias. |
| data/redondeoExacto.js | Exporta aplicar(valor): mitad hacia arriba al centavo. Exporta metadatos id=exacto, etiqueta=Exacto, orden=0. | Sin errores para valores del contrato. |
| data/redondeoHaciaArriba.js | Exporta aplicar(valor): techo al múltiplo de 100 centavos, manteniendo los enteros. id=hacia-arriba, etiqueta=Hacia arriba, orden=1. | Sin errores para valores del contrato. |
| presentation/formateadorMoneda.js | formatearMoneda(importeCentavos) recibe bigint válido y devuelve string con punto y exactamente dos decimales, sin símbolo ni agrupación. No redondea. | Sin errores para valores del contrato. |
| presentation/useDivisor.js | useDivisor(dependencias) recibe funciones y catálogo; retorna entradas, modo, modos, resultadoFormateado, error, cambiarCampo, cambiarModo y calcular. Coordina useState, no importa data. | Publica errores de validarEntrada. No crea estrategias ni los sustituye por errores de usuario si hay un fallo de programación. |
| presentation/PantallaDivisor.jsx | PantallaDivisor({ dependencias }) usa el hook y representa campos, opciones, botón, mensaje y resultado por persona. | Expone los errores del hook. No valida ni calcula por cuenta propia. |
| main.jsx | Descubre exportaciones de estrategias, construye objetos { aplicar }, catálogo/dependencias y monta la pantalla con createRoot. | Metadatos duplicados o contrato ausente son errores de composición, identificados por tests explícitos y al iniciar la aplicación, no por el build por sí solo ni como entrada del usuario. |

## Semántica numérica

Si C son centavos y P centésimas de porcentaje, la propina antes del reparto es
mitad-arriba(C * P / 10000). Esa política fija cumple los supuestos de la spec; la
estrategia inyectada determina exclusivamente el redondeo final por persona.

Para valor { numerador: a, denominador: b }:
- Exacto: cociente entero a/b, incrementado si 2*(a mod b) >= b.
- Hacia arriba: techo de a/(100*b), multiplicado por 100.

Ambas fórmulas operan sobre BigInt no negativos; cero retorna cero. El formateador
separa unidades y resto de centavos y rellena este último a dos cifras.

Ejemplos de contrato: {1000n, 3n} representa 333.33… centavos; exacto retorna 333n y
hacia arriba 400n. {3000n, 1n} retorna 3000n en ambos modos. {201n, 2n} retorna
101n en exacto. Los ejemplos abreviados usan el orden numerador, denominador.

## Inyección y extensión

main descubre eager ./data/redondeo*.js, ordena por orden e id y crea allí cada objeto
{ aplicar }. Inyecta el catálogo junto a funciones del dominio y formateador. El hook
resuelve por id la estrategia seleccionada; no compara clases ni modos mediante switch.
La pantalla genera opciones desde el catálogo, sin etiquetas fijas en sus condicionales.

Una nueva política añade su módulo y pruebas, con id único, etiqueta, orden y aplicar.
No cambia cálculo, validación, hook, pantalla ni main. La carga eager evita un acceso
adicional a red al cambiar modo. Data puede usar tipos JSDoc del domain; nunca React/DOM.
El glob es infraestructura exclusiva de main, no API del dominio.

## Pruebas del contrato

Vitest aplica una misma batería a las funciones aplicar exportadas: tipo bigint,
no negatividad, pureza, determinismo, cero, enteros y ausencia de mutación del racional.
Las pruebas específicas verifican la política matemática de cada una; LSP no exige
resultados iguales para políticas distintas. Tests de integración componen dobles
para verificar inyección sin crear implementaciones productivas fuera de main.
Un test de arquitectura comprueba importaciones prohibidas y referencias concretas
fuera de main; los tests y tooling no pertenecen al grafo productivo de capas.
