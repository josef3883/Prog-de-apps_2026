import { expect, it } from 'vitest'
import { crearDependencias } from '../../src/main.jsx'

const valido = { id: 'exacto', etiqueta: 'Exacto', orden: 0, aplicar: () => 0n }

it('compone un catálogo ordenado y objetos de contrato mínimo', () => {
  const dependencias = crearDependencias({ b: { ...valido, id: 'otro', orden: 1 }, a: valido })
  expect(dependencias.modos.map((modo) => modo.id)).toEqual(['exacto', 'otro'])
  expect(Object.keys(dependencias.modos[0].estrategia)).toEqual(['aplicar'])
})
it('rechaza ids duplicados explícitamente', () => {
  expect(() => crearDependencias({ a: valido, b: valido })).toThrow('duplicado')
})
it.each([
  { aplicar: undefined }, { id: '' }, { etiqueta: '' }, { orden: NaN }, { orden: undefined },
])('rechaza exportaciones inválidas %o', (cambio) => {
  expect(() => crearDependencias({ a: { ...valido, ...cambio } })).toThrow('inválidos')
})
it('rechaza un catálogo sin el modo inicial', () => {
  expect(() => crearDependencias({ a: { ...valido, id: 'otro' } })).toThrow('inicial exacto')
})
