// @vitest-environment jsdom
import { expect, it } from 'vitest'
import { PantallaDivisor } from '../../src/presentation/PantallaDivisor.jsx'
import { crearDependencias } from '../../src/main.jsx'
import { montar, completar, calcular, cambiar } from './soporte.jsx'

it.each([
  ['100.00', '4', '10', 'exacto', '27.50'],
  ['90.00', '3', '0', 'exacto', '30.00'],
  ['10.00', '3', '0', 'exacto', '3.33'],
  ['10.00', '3', '0', 'hacia-arriba', '4.00'],
  ['2.01', '2', '0', 'exacto', '1.01'],
  ['0.05', '1', '10', 'exacto', '0.06'],
  ['0', '1', '100', 'hacia-arriba', '0.00'],
  ['90', '3', '0', 'hacia-arriba', '30.00'],
  ['100,00', '4', '10,00', 'exacto', '27.50'],
])('calcula %s entre %s, propina %s, %s -> %s', async (monto, personas, propina, modo, esperado) => {
  const contenedor = await montar(<PantallaDivisor dependencias={crearDependencias()} />)
  expect(contenedor.querySelectorAll('form')).toHaveLength(1)
  expect(contenedor.querySelectorAll('input')).toHaveLength(3)
  for (const input of contenedor.querySelectorAll('input')) {
    expect(contenedor.querySelector(`label[for="${input.id}"]`)).not.toBeNull()
  }
  expect([...contenedor.querySelectorAll('option')].map((opcion) => opcion.textContent))
    .toEqual(['Exacto', 'Hacia arriba'])
  await completar(contenedor, monto, personas, propina, modo)
  expect(contenedor.querySelector('output')).toBeNull()
  const inicio = performance.now()
  await calcular(contenedor)
  expect(contenedor.querySelector('output').textContent).toBe(`${esperado} por persona`)
  expect(performance.now() - inicio).toBeLessThan(1000)
  expect(contenedor.querySelector('[role="alert"]')).toBeNull()
  await cambiar(contenedor, 'modo', modo === 'exacto' ? 'hacia-arriba' : 'exacto')
  expect(contenedor.querySelector('output')).toBeNull()
})
