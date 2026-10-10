import { expect, it, vi } from 'vitest'
import { calcularDivision } from '../../src/domain/calcularDivision.js'

it('redondea primero la propina y entrega un racional a la dependencia', () => {
  const aplicar = vi.fn(() => 6n)
  const cuenta = Object.freeze({ montoCentavos: 5n, personas: 1n, propinaCentesimas: 1000n })
  expect(calcularDivision(cuenta, { aplicar })).toEqual({ importeCentavos: 6n })
  expect(aplicar).toHaveBeenCalledExactlyOnceWith({ numerador: 6n, denominador: 1n })
})
it('conserva el reparto fraccionario sin formatear ni identificar la estrategia', () => {
  const aplicar = vi.fn(() => 333n)
  expect(calcularDivision({ montoCentavos: 1000n, personas: 3n, propinaCentesimas: 0n }, { aplicar }))
    .toEqual({ importeCentavos: 333n })
  expect(aplicar).toHaveBeenCalledExactlyOnceWith({ numerador: 1000n, denominador: 3n })
})
it('propaga los errores de programación de una dependencia', () => {
  const error = new Error('dependencia rota')
  expect(() => calcularDivision({ montoCentavos: 1n, personas: 1n, propinaCentesimas: 0n },
    { aplicar() { throw error } })).toThrow(error)
})
