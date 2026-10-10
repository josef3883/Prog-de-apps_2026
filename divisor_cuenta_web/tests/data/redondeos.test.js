import { expect, it } from 'vitest'
import { aplicar as exacto } from '../../src/data/redondeoExacto.js'
import { aplicar as arriba } from '../../src/data/redondeoHaciaArriba.js'

it.each([
  [1000n, 3n, 333n, 400n], [201n, 2n, 101n, 200n],
  [3000n, 1n, 3000n, 3000n], [0n, 3n, 0n, 0n],
  [199n, 2n, 100n, 100n], [20001n, 200n, 100n, 200n],
  [900719925474099301n, 1n, 900719925474099301n, 900719925474099400n],
])('redondea %s/%s centavos', (numerador, denominador, esperadoExacto, esperadoArriba) => {
  expect(exacto({ numerador, denominador })).toBe(esperadoExacto)
  expect(arriba({ numerador, denominador })).toBe(esperadoArriba)
})
