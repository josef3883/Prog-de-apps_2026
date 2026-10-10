/**
 * Presenta centavos ya redondeados sin elegir una moneda o política de negocio.
 * @param {bigint} importeCentavos Entero >= 0, producido por el cálculo.
 * @returns {string} Unidades con punto y exactamente dos decimales, sin símbolo.
 * No falla dentro del contrato; otros tipos son errores de programación.
 */
export function formatearMoneda(importeCentavos) {
  return `${importeCentavos / 100n}.${String(importeCentavos % 100n).padStart(2, '0')}`
}
