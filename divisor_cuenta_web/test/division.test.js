import { describe, expect, it, vi } from 'vitest'
import { casos } from './casosDePrueba.js'
import { validarEntrada } from '../src/domain/validarEntrada.js'
import { calcularDivision } from '../src/domain/calcularDivision.js'
import * as redondeoExacto from '../src/data/redondeoExacto.js'
import * as redondeoHaciaArriba from '../src/data/redondeoHaciaArriba.js'

const estrategias = { exacto: redondeoExacto, arriba: redondeoHaciaArriba }

describe('División de cuenta: casos proporcionados', () => {
  for (const caso of casos) {
    it(caso.nombre, () => {
      // El espía delega al cálculo real y permite comprobar que los errores no lo invocan.
      const calcular = vi.fn(calcularDivision)
      const validacion = validarEntrada({
        monto: caso.monto,
        personas: caso.personas,
        propina: caso.propina,
      })

      if ('errorEsperado' in caso) {
        expect(validacion.ok).toBe(false)
        expect(validacion.error.mensaje).toBe(caso.errorEsperado)
        expect(calcular).not.toHaveBeenCalled()
        return
      }

      expect(caso).toHaveProperty('esperado')
      expect(validacion.ok).toBe(true)
      const resultado = calcular(validacion.cuenta, estrategias[caso.modo])
      // El contrato devuelve centavos bigint; los casos expresan unidades monetarias.
      expect(Number(resultado.importeCentavos) / 100).toBeCloseTo(caso.esperado, 2)
      expect(calcular).toHaveBeenCalledTimes(1)
    })
  }
})

it('LSP: el mismo cálculo acepta ambas estrategias sin comprobar su tipo', () => {
  const validacion = validarEntrada({ monto: 10, personas: 3, propina: 0 })
  expect(validacion.ok).toBe(true)

  const exacto = calcularDivision(validacion.cuenta, redondeoExacto)
  const haciaArriba = calcularDivision(validacion.cuenta, redondeoHaciaArriba)

  expect(Number(exacto.importeCentavos) / 100).toBeCloseTo(3.33, 2)
  expect(Number(haciaArriba.importeCentavos) / 100).toBeCloseTo(4.00, 2)
})
