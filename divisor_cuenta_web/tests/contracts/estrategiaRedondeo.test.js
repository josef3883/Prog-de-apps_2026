import { describe, expect, it } from 'vitest'
import { aplicar as exacto } from '../../src/data/redondeoExacto.js'
import { aplicar as arriba } from '../../src/data/redondeoHaciaArriba.js'

describe.each([['exacto', exacto], ['arriba', arriba]])('contrato %s', (_nombre, aplicar) => {
  it.each([[0n, 1n], [3000n, 1n], [1000n, 3n], [12345678901234567890n, 7n]])(
    'es sustituible para %s/%s sin mutación', (numerador, denominador) => {
      const valor = Object.freeze({ numerador, denominador })
      const salida = aplicar(valor)
      expect(typeof salida).toBe('bigint')
      expect(salida).toBeGreaterThanOrEqual(0n)
      expect(aplicar(valor)).toBe(salida)
      expect(valor).toEqual({ numerador, denominador })
      if (numerador === 0n || numerador === 3000n) expect(salida).toBe(numerador)
    },
  )
})
