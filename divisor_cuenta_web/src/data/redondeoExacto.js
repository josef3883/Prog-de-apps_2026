export const id = 'exacto'
export const etiqueta = 'Exacto'
export const orden = 0

/**
 * Implementa el modo exacto: centavo más cercano, con empate hacia arriba.
 * @param {import('../domain/estrategiaRedondeo.js').ValorRedondeo} valor Centavos racionales válidos.
 * @returns {bigint} Centavos redondeados; no falla dentro del contrato ni muta la entrada.
 */
export function aplicar({ numerador, denominador }) {
  return numerador / denominador + (2n * (numerador % denominador) >= denominador ? 1n : 0n)
}
