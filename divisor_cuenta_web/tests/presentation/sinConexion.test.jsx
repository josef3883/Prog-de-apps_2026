// @vitest-environment jsdom
import { expect, it, vi } from 'vitest'
import { PantallaDivisor } from '../../src/presentation/PantallaDivisor.jsx'
import { crearDependencias } from '../../src/main.jsx'
import { montar, completar, calcular } from './soporte.jsx'

it('A7 calcula con red y almacenamiento bloqueados, en ambos modos', async () => {
  const contenedor = await montar(<PantallaDivisor dependencias={crearDependencias()} />)
  const prohibido = vi.fn(() => { throw new Error('Acceso externo inesperado') })
  vi.stubGlobal('fetch', prohibido)
  vi.stubGlobal('XMLHttpRequest', prohibido)
  vi.stubGlobal('WebSocket', prohibido)
  vi.stubGlobal('indexedDB', { open: prohibido, deleteDatabase: prohibido })
  vi.spyOn(Storage.prototype, 'setItem').mockImplementation(prohibido)
  vi.spyOn(Storage.prototype, 'removeItem').mockImplementation(prohibido)
  vi.spyOn(Storage.prototype, 'clear').mockImplementation(prohibido)
  vi.spyOn(Document.prototype, 'cookie', 'set').mockImplementation(prohibido)
  for (const [modo, esperado] of [['exacto', '3.33'], ['hacia-arriba', '4.00']]) {
    await completar(contenedor, '10', '3', '0', modo)
    await calcular(contenedor)
    expect(contenedor.querySelector('output').textContent).toBe(`${esperado} por persona`)
  }
  expect(prohibido).not.toHaveBeenCalled()
})
