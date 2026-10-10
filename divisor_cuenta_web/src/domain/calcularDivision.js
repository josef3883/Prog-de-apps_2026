/**
 * Calcula sobre una cuenta válida para separar negocio, validación y presentación.
 * Redondea primero la propina al centavo (mitades arriba), mantiene el reparto racional
 * y delega únicamente el redondeo final. No instancia ni reconoce estrategias concretas.
 * @param {import('./cuenta.js').Cuenta} cuenta Datos numéricos válidos.
 * @param {import('./estrategiaRedondeo.js').EstrategiaRedondeo} estrategia Dependencia sustituible.
 * @returns {import('./resultado.js').Resultado} Centavos individuales.
 * Sin errores de usuario; propaga fallos de la dependencia o precondiciones incumplidas.
 */
export function calcularDivision(cuenta, estrategia) {
  const productoPropina = cuenta.montoCentavos * cuenta.propinaCentesimas
  const propina = productoPropina / 10000n + (2n * (productoPropina % 10000n) >= 10000n ? 1n : 0n)
  const valor = { numerador: cuenta.montoCentavos + propina, denominador: cuenta.personas }
  return Object.freeze({ importeCentavos: estrategia.aplicar(valor) })
}
