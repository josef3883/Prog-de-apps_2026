import { useDivisor } from './useDivisor.js'

/**
 * Representa una pantalla de reparto; recibe dependencias compuestas por main y devuelve JSX.
 * Delega validación/cálculo al hook. No produce errores de entrada propios; los muestra.
 */
export function PantallaDivisor({ dependencias }) {
  const divisor = useDivisor(dependencias)
  return (
    <main className="pagina">
      <header className="cabecera">
        <span className="marca" aria-hidden="true">÷</span>
        <span>Cuenta compartida</span>
        <span className="etiqueta-local">Sin conexión · Sin registro</span>
      </header>
      <section className="tarjeta" aria-labelledby="titulo">
        <div className="introduccion">
          <p className="antetitulo">A la mesa, las cuentas claras.</p>
          <h1 id="titulo">Divide la cuenta.<br /><span>Comparte el momento.</span></h1>
          <p>Incluye la propina y descubre cuánto paga cada persona.</p>
        </div>
        <form noValidate onSubmit={(evento) => { evento.preventDefault(); divisor.calcular() }}>
          <div className="campo">
            <label htmlFor="monto">Monto total</label>
            <input id="monto" name="monto" type="text" inputMode="decimal" placeholder="0.00"
              aria-invalid={divisor.error?.campo === 'monto'}
              aria-describedby={divisor.error?.campo === 'monto' ? 'error-monto' : undefined}
              value={divisor.entradas.monto} onChange={(evento) => divisor.cambiarCampo('monto', evento.target.value)} />
            {divisor.error?.campo === 'monto' && <p className="error" id="error-monto" role="alert">{divisor.error.mensaje}</p>}
          </div>
          <div className="fila-campos">
            <div className="campo">
              <label htmlFor="personas">Número de personas</label>
              <input id="personas" name="personas" type="text" inputMode="numeric" placeholder="Ej. 4"
                aria-invalid={divisor.error?.campo === 'personas'}
                aria-describedby={divisor.error?.campo === 'personas' ? 'error-personas' : undefined}
                value={divisor.entradas.personas} onChange={(evento) => divisor.cambiarCampo('personas', evento.target.value)} />
              {divisor.error?.campo === 'personas' && <p className="error" id="error-personas" role="alert">{divisor.error.mensaje}</p>}
            </div>
            <div className="campo">
              <label htmlFor="propina">Propina (%)</label>
              <input id="propina" name="propina" type="text" inputMode="decimal" placeholder="Ej. 10"
                aria-invalid={divisor.error?.campo === 'propina'}
                aria-describedby={divisor.error?.campo === 'propina' ? 'error-propina' : undefined}
                value={divisor.entradas.propina} onChange={(evento) => divisor.cambiarCampo('propina', evento.target.value)} />
              {divisor.error?.campo === 'propina' && <p className="error" id="error-propina" role="alert">{divisor.error.mensaje}</p>}
            </div>
          </div>
          <div className="campo">
            <label htmlFor="modo">Cómo repartir</label>
            <select id="modo" name="modo" value={divisor.modo} onChange={(evento) => divisor.cambiarModo(evento.target.value)}>
              {divisor.modos.map((opcion) => <option key={opcion.id} value={opcion.id}>{opcion.etiqueta}</option>)}
            </select>
            <p className="ayuda">Exacto: al centavo. Hacia arriba: al entero más cercano por encima.</p>
          </div>
          <button type="submit">Calcular <span aria-hidden="true">↗</span></button>
          <div className="zona-resultado" aria-live="polite" aria-atomic="true">
            {divisor.resultadoFormateado !== null
              ? <output>{divisor.resultadoFormateado} <span>por persona</span></output>
              : <p className="espera">Tu parte de la cuenta aparecerá aquí.</p>}
          </div>
        </form>
      </section>
      <footer>Hecho para compartir. Tus datos se quedan en esta pantalla.</footer>
    </main>
  )
}
