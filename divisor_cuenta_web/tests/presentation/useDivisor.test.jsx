// @vitest-environment jsdom
import { expect, it, vi } from 'vitest'
import { useEffect } from 'react'
import { useDivisor } from '../../src/presentation/useDivisor.js'
import { montar, cambiar, calcular } from './soporte.jsx'

it('recibe dependencias, no calcula al editar y usa la estrategia elegida por id', async () => {
  const estrategia = { aplicar: vi.fn() }
  const cuenta = { montoCentavos: 1n, personas: 1n, propinaCentesimas: 0n }
  const dependencias = {
    modos: [{ id: 'exacto', etiqueta: 'Prueba', estrategia }],
    validarEntrada: vi.fn(() => ({ ok: true, cuenta })),
    calcularDivision: vi.fn(() => ({ importeCentavos: 25n })),
    formatearMoneda: vi.fn(() => '0.25'),
  }
  let estado
  function Prueba() {
    const actual = useDivisor(dependencias)
    useEffect(() => { estado = actual })
    return <form onSubmit={(e) => { e.preventDefault(); actual.calcular() }}>
      <input name="monto" value={actual.entradas.monto} onChange={(e) => actual.cambiarCampo('monto', e.target.value)} />
    </form>
  }
  const contenedor = await montar(<Prueba />)
  expect(estado.entradas).toEqual({ monto: '', personas: '', propina: '' })
  expect(estado.modo).toBe('exacto')
  expect(estado.error).toBeNull()
  expect(estado.resultadoFormateado).toBeNull()
  await cambiar(contenedor, 'monto', '1,00')
  expect(dependencias.calcularDivision).not.toHaveBeenCalled()
  await calcular(contenedor)
  expect(dependencias.validarEntrada).toHaveBeenCalledWith({ monto: '1,00', personas: '', propina: '' })
  expect(dependencias.calcularDivision).toHaveBeenCalledExactlyOnceWith(cuenta, estrategia)
  expect(estado.resultadoFormateado).toBe('0.25')
  await cambiar(contenedor, 'monto', '2')
  expect(estado.resultadoFormateado).toBeNull()
  expect(dependencias.calcularDivision).toHaveBeenCalledTimes(1)
})
