import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

class CalcularDivision {
  const CalcularDivision();

  Resultado calcular(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final propinaCentimos = _calcularPropinaCentimos(cuenta);
    final totalConPropinaCentimos = cuenta.montoCentimos + propinaCentimos;
    final importePorPersonaCentimos = estrategia.calcularParte(
      totalConPropinaCentimos: totalConPropinaCentimos,
      cantidadPersonas: cuenta.cantidadPersonas,
    );

    return Resultado(
      importePorPersonaCentimos: importePorPersonaCentimos,
      propinaCentimos: propinaCentimos,
      totalConPropinaCentimos: totalConPropinaCentimos,
    );
  }

  int _calcularPropinaCentimos(Cuenta cuenta) {
    final numerador =
        BigInt.from(cuenta.montoCentimos) *
        BigInt.from(cuenta.propinaPuntosBasicos);
    final divisor = BigInt.from(10000);
    final mitad = divisor ~/ BigInt.from(2);

    return ((numerador + mitad) ~/ divisor).toInt();
  }
}
