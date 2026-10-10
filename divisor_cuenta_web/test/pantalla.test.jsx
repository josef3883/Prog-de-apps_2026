// @vitest-environment jsdom
import { afterEach, describe, expect, it } from 'vitest'
import { cleanup, fireEvent, render, screen } from '@testing-library/react'
import { PantallaDivisor } from '../src/presentation/PantallaDivisor.jsx'
import { crearDependencias } from '../src/main.jsx'

afterEach(cleanup)

describe('Pantalla del divisor de cuenta', () => {
  it('muestra 27.50 al calcular 100 entre 4 personas con 10 % de propina', () => {
    render(<PantallaDivisor dependencias={crearDependencias()} />)

    fireEvent.change(screen.getByLabelText('Monto total'), { target: { value: '100' } })
    fireEvent.change(screen.getByLabelText('Número de personas'), { target: { value: '4' } })
    fireEvent.change(screen.getByLabelText('Propina (%)'), { target: { value: '10' } })
    fireEvent.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByText('27.50')).toBeInTheDocument()
    expect(screen.getByRole('status')).toHaveTextContent('27.50 por persona')
  })

  it('muestra un error con cero personas y no muestra un resultado numérico', () => {
    render(<PantallaDivisor dependencias={crearDependencias()} />)

    fireEvent.change(screen.getByLabelText('Monto total'), { target: { value: '50' } })
    fireEvent.change(screen.getByLabelText('Número de personas'), { target: { value: '0' } })
    fireEvent.change(screen.getByLabelText('Propina (%)'), { target: { value: '0' } })
    fireEvent.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByRole('alert')).toHaveTextContent('Debe haber al menos una persona')
    // El resultado se representa con <output>, cuyo rol implícito es status.
    expect(screen.queryByRole('status')).not.toBeInTheDocument()
  })

  it('muestra Monto inválido al calcular con abc en el monto', () => {
    render(<PantallaDivisor dependencias={crearDependencias()} />)

    fireEvent.change(screen.getByLabelText('Monto total'), { target: { value: 'abc' } })
    fireEvent.click(screen.getByRole('button', { name: 'Calcular' }))

    expect(screen.getByRole('alert')).toHaveTextContent('Monto inválido')
  })
})
