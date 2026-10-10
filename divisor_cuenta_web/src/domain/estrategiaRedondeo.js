/**
 * @typedef {Readonly<{numerador: bigint, denominador: bigint}>} ValorRedondeo
 * Racional de centavos: numerador >= 0, denominador > 0.
 * @typedef {{aplicar: (valor: ValorRedondeo) => bigint}} EstrategiaRedondeo
 * aplicar es pura, síncrona y determinista, conserva su entrada y devuelve centavos >= 0.
 * No falla con entradas del contrato; fuera de él es un error de programación,
 * no un error de entrada del usuario. Las implementaciones se componen solo en main.
 */
export {}
