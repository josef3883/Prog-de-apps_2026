/**
 * Convierte texto decimal ya validado a centésimas exactas, sin Number.
 * Existe para compartir la normalización de monto y porcentaje.
 * @param {string} texto Decimal con parte entera y hasta dos cifras decimales.
 * @returns {bigint} Centésimas; no falla si se cumple la precondición léxica.
 */
function aCentesimas(texto) {
  const [entero, decimal = ''] = texto.replace(',', '.').split('.')
  return BigInt(entero) * 100n + BigInt(decimal.padEnd(2, '0'))
}

/**
 * Valida y normaliza los tres campos, para mantener el cálculo libre de validación.
 * Prioridad: monto, personas, propina. Errores de usuario se devuelven como datos.
 * FR-009 tiene prioridad para personas numéricas <= 0, incluso negativas fraccionarias.
 * @param {{monto: string|number, personas: string|number, propina: string|number}} entrada
 * Texto de formulario o valores numéricos; NaN e Infinity se rechazan como entradas inválidas.
 * @returns {{ok: true, cuenta: import('./cuenta.js').Cuenta}|{ok: false, error: {campo: string, mensaje: string}}}
 * No lanza errores para campos textuales o numéricos; otros tipos incumplen el contrato.
 */
export function validarEntrada(entrada) {
  const monto = String(entrada.monto).trim()
  const personas = String(entrada.personas).trim()
  const propina = String(entrada.propina).trim()
  const decimal = /^\d+(?:[.,]\d{1,2})?$/
  if (!decimal.test(monto)) {
    return { ok: false, error: { campo: 'monto', mensaje: 'Monto inválido' } }
  }
  // Detecta negativos y cero antes de exigir entero; sin convertir cantidades a Number.
  const numeroPersonas = /^[+-]?\d+(?:[.,]\d+)?$/.test(personas)
  const esCero = numeroPersonas && !/[1-9]/.test(personas)
  const esNegativo = numeroPersonas && personas.startsWith('-')
  if (esCero || esNegativo) {
    return { ok: false, error: { campo: 'personas', mensaje: 'Debe haber al menos una persona' } }
  }
  if (!/^\+?\d+$/.test(personas)) {
    return { ok: false, error: { campo: 'personas', mensaje: 'Número de personas inválido' } }
  }
  if (!decimal.test(propina) || aCentesimas(propina) > 10000n) {
    return { ok: false, error: { campo: 'propina', mensaje: 'Propina inválida' } }
  }
  return {
    ok: true,
    cuenta: Object.freeze({
      montoCentavos: aCentesimas(monto),
      personas: BigInt(personas),
      propinaCentesimas: aCentesimas(propina),
    }),
  }
}
