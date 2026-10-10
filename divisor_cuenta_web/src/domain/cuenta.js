/**
 * Cuenta numérica validada, independiente de interfaz y estrategia.
 * @typedef {Readonly<{montoCentavos: bigint, personas: bigint, propinaCentesimas: bigint}>} Cuenta
 * montoCentavos >= 0; personas >= 1; propinaCentesimas entre 0 y 10000 inclusive.
 * No contiene funciones: validarEntrada produce este valor, no un servicio concreto.
 */
export {}
