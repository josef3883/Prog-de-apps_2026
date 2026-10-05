import '../domain/calcular_division.dart';
import '../domain/resultado.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/validar_entrada.dart';

class OpcionRedondeo {
  const OpcionRedondeo({required this.etiqueta, required this.estrategia});

  final String etiqueta;
  final EstrategiaRedondeo estrategia;
}

class EstadoCalculo {
  const EstadoCalculo({this.resultado, this.error});

  final Resultado? resultado;
  final ErrorValidacion? error;
}

class DivisorController {
  DivisorController({
    required this._validarEntrada,
    required this._calcularDivision,
    required List<OpcionRedondeo> opcionesRedondeo,
  }) : opcionesRedondeo = List.unmodifiable(opcionesRedondeo);

  final ValidarEntrada _validarEntrada;
  final CalcularDivision _calcularDivision;
  final List<OpcionRedondeo> opcionesRedondeo;

  String mensajeError(ErrorValidacion error) => switch (error) {
    ErrorValidacion.montoInvalido => 'Monto inválido',
    ErrorValidacion.debeHaberUnaPersona => 'Debe haber al menos una persona',
    ErrorValidacion.numeroPersonasInvalido => 'Número de personas inválido',
    ErrorValidacion.propinaInvalida => 'Propina inválida',
  };

  EstadoCalculo calcular({
    required String monto,
    required String personas,
    required String propina,
    required OpcionRedondeo opcionRedondeo,
  }) {
    final validacion = _validarEntrada.validar(
      monto: monto,
      personas: personas,
      propina: propina,
    );
    final cuenta = validacion.cuenta;

    if (cuenta == null) {
      return EstadoCalculo(error: validacion.error);
    }

    return EstadoCalculo(
      resultado: _calcularDivision.calcular(cuenta, opcionRedondeo.estrategia),
    );
  }
}
