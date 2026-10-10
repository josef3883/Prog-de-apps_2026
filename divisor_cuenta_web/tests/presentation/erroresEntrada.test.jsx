// @vitest-environment jsdom
import { expect, it, vi } from 'vitest'
import { PantallaDivisor } from '../../src/presentation/PantallaDivisor.jsx'
import { crearDependencias } from '../../src/main.jsx'
import { casosInvalidos } from '../domain/casosInvalidos.js'
import { montar, completar, cambiar, calcular } from './soporte.jsx'

it.each(casosInvalidos)('%s=%s muestra %s, sin resultado ni cálculo', async (campo, valor, mensaje) => {
  const originales = crearDependencias()
  const calcularDivision = vi.fn(originales.calcularDivision)
  const dependencias = { ...originales, calcularDivision }
  const contenedor = await montar(<PantallaDivisor dependencias={dependencias} />)
  await completar(contenedor)
  await calcular(contenedor)
  expect(contenedor.querySelector('output')).not.toBeNull()
  calcularDivision.mockClear()
  await cambiar(contenedor, campo, valor)
  await calcular(contenedor)
  expect(contenedor.querySelector('[role="alert"]').textContent).toBe(mensaje)
  expect(contenedor.querySelector('output')).toBeNull()
  expect(calcularDivision).not.toHaveBeenCalled()
  const input = contenedor.querySelector(`[name="${campo}"]`)
  expect(input.getAttribute('aria-invalid')).toBe('true')
  expect(input.getAttribute('aria-describedby')).toContain(`error-${campo}`)
  await cambiar(contenedor, campo, { monto: '100', personas: '4', propina: '10' }[campo])
  expect(contenedor.querySelector('[role="alert"]')).toBeNull()
  expect(contenedor.querySelector('output')).toBeNull()
  await calcular(contenedor)
  expect(contenedor.querySelector('output').textContent).toBe('27.50 por persona')
})
