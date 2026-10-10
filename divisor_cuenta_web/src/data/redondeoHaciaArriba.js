export const id = 'hacia-arriba'
export const etiqueta = 'Hacia arriba'
export const orden = 1

/**
 * Implementa techo al entero monetario sin aumentar un importe ya entero.
 * @param {import('../domain/estrategiaRedondeo.js').ValorRedondeo} valor Centavos racionales válidos.
 * @returns {bigint} Centavos múltiplos de 100; no falla dentro del contrato ni muta la entrada.
 */
export function aplicar({ numerador, denominador }) {
  const divisor = denominador * 100n
  return ((numerador + divisor - 1n) / divisor) * 100n
}
