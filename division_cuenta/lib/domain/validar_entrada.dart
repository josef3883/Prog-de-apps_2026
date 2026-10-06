import 'cuenta.dart';

enum ErrorValidacion {
  montoInvalido,
  debeHaberUnaPersona,
  numeroPersonasInvalido,
  propinaInvalida,
}

class ResultadoValidacion {
  const ResultadoValidacion.valida(this.cuenta)
    : assert(cuenta != null),
      error = null;

  const ResultadoValidacion.invalida(this.error)
    : assert(error != null),
      cuenta = null;

  final Cuenta? cuenta;
  final ErrorValidacion? error;

  bool get esValida => cuenta != null;
}

class ValidarEntrada {
  const ValidarEntrada();

  static final RegExp _formatoDecimal = RegExp(r'^\d+(?:[.,]\d{1,2})?$');

  ResultadoValidacion validar({
    required String monto,
    required String personas,
    required String propina,
  }) {
    final montoCentimos = _leerCentimos(monto);
    if (montoCentimos == null) {
      return const ResultadoValidacion.invalida(ErrorValidacion.montoInvalido);
    }

    final cantidadPersonas = int.tryParse(personas.trim());
    if (cantidadPersonas == null) {
      return const ResultadoValidacion.invalida(
        ErrorValidacion.numeroPersonasInvalido,
      );
    }
    if (cantidadPersonas <= 0) {
      return const ResultadoValidacion.invalida(
        ErrorValidacion.debeHaberUnaPersona,
      );
    }

    final propinaPuntosBasicos = _leerCentimos(propina);
    if (propinaPuntosBasicos == null || propinaPuntosBasicos > 10000) {
      return const ResultadoValidacion.invalida(
        ErrorValidacion.propinaInvalida,
      );
    }

    return ResultadoValidacion.valida(
      Cuenta(
        montoCentimos: montoCentimos,
        cantidadPersonas: cantidadPersonas,
        propinaPuntosBasicos: propinaPuntosBasicos,
      ),
    );
  }

  int? _leerCentimos(String texto) {
    final valor = texto.trim();
    if (!_formatoDecimal.hasMatch(valor)) {
      return null;
    }

    final partes = valor.replaceAll(',', '.').split('.');
    final decimales = partes.length == 2 ? partes[1].padRight(2, '0') : '00';
    return int.tryParse('${partes[0]}$decimales');
  }
}
