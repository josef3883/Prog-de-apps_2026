import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { validarEntrada } from './domain/validarEntrada.js'
import { calcularDivision } from './domain/calcularDivision.js'
import { formatearMoneda } from './presentation/formateadorMoneda.js'
import { PantallaDivisor } from './presentation/PantallaDivisor.jsx'
import './index.css'

const modulosRedondeo = import.meta.glob('./data/redondeo*.js', { eager: true })

/**
 * Compone dependencias concretas exclusivamente aquí, para mantener DIP y OCP.
 * @param {Record<string, {id: string, etiqueta: string, orden: number, aplicar: Function}>} modulos
 * Exportaciones descubiertas por Vite; admite módulos sustitutos para probar composición.
 * @returns {object} Funciones y catálogo inyectables al hook/pantalla.
 * @throws {Error} Si falta un contrato/metadato, hay ids duplicados o no existe exacto.
 */
export function crearDependencias(modulos = modulosRedondeo) {
  const ids = new Set()
  const modos = Object.values(modulos).map((modulo) => {
    if (typeof modulo.id !== 'string' || !modulo.id.trim()
      || typeof modulo.etiqueta !== 'string' || !modulo.etiqueta.trim()
      || !Number.isFinite(modulo.orden) || typeof modulo.aplicar !== 'function') {
      throw new Error('Contrato o metadatos de redondeo inválidos')
    }
    if (ids.has(modulo.id)) throw new Error(`Modo de redondeo duplicado: ${modulo.id}`)
    ids.add(modulo.id)
    return Object.freeze({
      id: modulo.id, etiqueta: modulo.etiqueta, orden: modulo.orden,
      estrategia: Object.freeze({ aplicar: modulo.aplicar }),
    })
  }).sort((a, b) => a.orden - b.orden || a.id.localeCompare(b.id))
  if (!ids.has('exacto')) throw new Error('Falta el modo inicial exacto')
  return Object.freeze({ validarEntrada, calcularDivision, formatearMoneda, modos: Object.freeze(modos) })
}

/**
 * Monta la aplicación con dependencias compuestas aquí.
 * @param {HTMLElement} elemento Contenedor existente; errores de composición se propagan.
 * @returns {ReturnType<typeof createRoot>} Raíz para permitir desmontaje en pruebas.
 */
export function montarAplicacion(elemento) {
  const dependencias = crearDependencias()
  const raiz = createRoot(elemento)
  raiz.render(<StrictMode><PantallaDivisor dependencias={dependencias} /></StrictMode>)
  return raiz
}

const elemento = typeof document === 'undefined' ? null : document.getElementById('root')
if (elemento) montarAplicacion(elemento)
