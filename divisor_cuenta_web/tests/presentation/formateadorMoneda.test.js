import { expect, it } from 'vitest'
import { formatearMoneda } from '../../src/presentation/formateadorMoneda.js'

it.each([[0n, '0.00'], [1n, '0.01'], [100n, '1.00'], [2750n, '27.50'],
  [900719925474099301n, '9007199254740993.01']])('formatea %s sin redondear', (valor, esperado) => {
  expect(formatearMoneda(valor)).toBe(esperado)
})
