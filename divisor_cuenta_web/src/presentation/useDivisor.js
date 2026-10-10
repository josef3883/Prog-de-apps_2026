import { useState } from 'react'

/**
 * Coordina el formulario local para separar interacción y reglas de negocio.
 * @param {{validarEntrada: Function, calcularDivision: Function, formatearMoneda: Function,
 * modos: Array<{id: string, etiqueta: string, estrategia: import('../domain/estrategiaRedondeo.js').EstrategiaRedondeo}>}} dependencias
 * Funciones y catálogo ya compuestos por main; debe existir el modo inicial exacto.
 * @returns {object} Entradas, modo, opciones, salida, error y acciones de UI.
 * Los errores de entrada son estado; errores de programación de dependencias se propagan.
 */
export function useDivisor({ validarEntrada, calcularDivision, formatearMoneda, modos }) {
  const [entradas, setEntradas] = useState({ monto: '', personas: '', propina: '' })
  const [modo, setModo] = useState('exacto')
  const [resultadoFormateado, setResultadoFormateado] = useState(null)
  const [error, setError] = useState(null)

  /** Actualiza un campo textual y limpia salida/error; no calcula. Campo debe existir. */
  function cambiarCampo(campo, valor) {
    setEntradas((actuales) => ({ ...actuales, [campo]: valor }))
    setResultadoFormateado(null)
    setError(null)
  }

  /** Selecciona un id del catálogo y limpia salida/error; no crea una estrategia ni calcula. */
  function cambiarModo(id) {
    setModo(id)
    setResultadoFormateado(null)
    setError(null)
  }

  /** Valida al solicitar cálculo; recibe estado local, devuelve void y publica la salida. */
  function calcular() {
    const validacion = validarEntrada(entradas)
    if (!validacion.ok) {
      setResultadoFormateado(null)
      setError(validacion.error)
      return
    }
    const seleccionado = modos.find((opcion) => opcion.id === modo)
    const resultado = calcularDivision(validacion.cuenta, seleccionado.estrategia)
    setResultadoFormateado(formatearMoneda(resultado.importeCentavos))
    setError(null)
  }

  return { entradas, modo, modos, resultadoFormateado, error, cambiarCampo, cambiarModo, calcular }
}
