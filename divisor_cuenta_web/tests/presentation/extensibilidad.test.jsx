// @vitest-environment jsdom
import { expect, it, vi } from 'vitest'
import { crearDependencias } from '../../src/main.jsx'
import { PantallaDivisor } from '../../src/presentation/PantallaDivisor.jsx'
import { montar, completar, calcular } from './soporte.jsx'

it('ofrece y utiliza un modo adicional sin editar consumidores', async () => {
  const aplicar = vi.fn(() => 1234n)
  const dependencias = crearDependencias({
    inicial: { id: 'exacto', etiqueta: 'Exacto de prueba', orden: 0, aplicar: () => 0n },
    nuevo: { id: 'nuevo', etiqueta: 'Otro modo', orden: 3, aplicar },
  })
  const contenedor = await montar(<PantallaDivisor dependencias={dependencias} />)
  expect(contenedor.querySelector('option[value="nuevo"]').textContent).toBe('Otro modo')
  await completar(contenedor, '10', '3', '0', 'nuevo')
  await calcular(contenedor)
  expect(aplicar).toHaveBeenCalledExactlyOnceWith({ numerador: 1000n, denominador: 3n })
  expect(contenedor.querySelector('output').textContent).toBe('12.34 por persona')
})
