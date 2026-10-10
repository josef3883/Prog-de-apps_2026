import { act } from 'react'
import { createRoot } from 'react-dom/client'
import { afterEach, vi } from 'vitest'

globalThis.IS_REACT_ACT_ENVIRONMENT = true
const montajes = []

/** Monta un elemento React en jsdom para probar su interfaz; retorna el contenedor. */
export async function montar(elemento) {
  const contenedor = document.createElement('div')
  document.body.append(contenedor)
  const root = createRoot(contenedor)
  montajes.push({ root, contenedor })
  await act(async () => root.render(elemento))
  return contenedor
}

/** Cambia un input/select usando su setter nativo y emite el evento de React. */
export async function cambiar(contenedor, nombre, valor) {
  const control = contenedor.querySelector(`[name="${nombre}"]`)
  const prototipo = control.tagName === 'SELECT' ? HTMLSelectElement.prototype : HTMLInputElement.prototype
  Object.getOwnPropertyDescriptor(prototipo, 'value').set.call(control, valor)
  await act(async () => {
    control.dispatchEvent(new Event(control.tagName === 'SELECT' ? 'change' : 'input', { bubbles: true }))
  })
}

/** Envía el formulario como el botón Calcular, esperando que React termine de actualizar. */
export async function calcular(contenedor) {
  await act(async () => {
    contenedor.querySelector('form').dispatchEvent(new Event('submit', { bubbles: true, cancelable: true }))
  })
}

/** Completa las entradas de una solicitud de prueba sin calcular. */
export async function completar(contenedor, monto = '100', personas = '4', propina = '10', modo = 'exacto') {
  for (const [nombre, valor] of Object.entries({ monto, personas, propina, modo })) {
    await cambiar(contenedor, nombre, valor)
  }
}

afterEach(async () => {
  for (const { root, contenedor } of montajes.splice(0)) {
    await act(async () => root.unmount())
    contenedor.remove()
  }
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})
