// Cada categoría de SC-002 se usa tanto en dominio como desde la pantalla.
export const casosInvalidos = [
  ...['', '-1', 'abc', 'Infinity', 'NaN', '1,000', '1.000', '1,234.56', '1.234,56', '1.001', '.5', '1.', '1e2']
    .map((valor) => ['monto', valor, 'Monto inválido']),
  ...['0', '-1', '-0.5', '-0,5', '0.00', '-0']
    .map((valor) => ['personas', valor, 'Debe haber al menos una persona']),
  ...['', 'abc', '1.5', 'Infinity', 'NaN', '1e2', '1,000']
    .map((valor) => ['personas', valor, 'Número de personas inválido']),
  ...['', 'abc', 'Infinity', 'NaN', '-1', '100.01', '100,01', '1,000', '1.000', '1,234.56', '1.234,56', '0.001', '.5', '1.', '1e2']
    .map((valor) => ['propina', valor, 'Propina inválida']),
]
