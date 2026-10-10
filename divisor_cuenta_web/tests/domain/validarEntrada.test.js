import { describe, expect, it } from 'vitest'
import { validarEntrada } from '../../src/domain/validarEntrada.js'
import { casosInvalidos } from './casosInvalidos.js'

describe('normalización decimal exacta', () => {
  it.each(['10', '10.0', '10,0', '10.00', ' 10,00 '])('normaliza %s', (monto) => {
    expect(validarEntrada({ monto, personas: '2', propina: '10,25' })).toEqual({
      ok: true, cuenta: { montoCentavos: 1000n, personas: 2n, propinaCentesimas: 1025n },
    })
  })
  it.each(['0', '100'])('acepta límites de propina %s y monto cero', (propina) => {
    expect(validarEntrada({ monto: '0', personas: '+1', propina }).ok).toBe(true)
  })
  it('no pierde centavos mayores que el entero seguro de Number', () => {
    expect(validarEntrada({ monto: '9007199254740993.01', personas: '9007199254740993', propina: '0' }).cuenta)
      .toEqual({ montoCentavos: 900719925474099301n, personas: 9007199254740993n, propinaCentesimas: 0n })
  })
})

describe('errores de entrada', () => {
  it.each(casosInvalidos)('%s=%s produce %s', (campo, valor, mensaje) => {
    expect(validarEntrada({ monto: '100', personas: '4', propina: '10', [campo]: valor }))
      .toEqual({ ok: false, error: { campo, mensaje } })
  })
  it('prioriza monto, después personas y por último propina', () => {
    expect(validarEntrada({ monto: '', personas: '0', propina: '-1' }).error.campo).toBe('monto')
    expect(validarEntrada({ monto: '1', personas: '0', propina: '-1' }).error.campo).toBe('personas')
    expect(validarEntrada({ monto: '1', personas: '1', propina: '-1' }).error.campo).toBe('propina')
  })
})
