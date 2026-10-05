import '../domain/estrategia_redondeo.dart';

class RedondeoExacto implements EstrategiaRedondeo {
  const RedondeoExacto();

  @override
  int calcularParte({
    required int totalConPropinaCentimos,
    required int cantidadPersonas,
  }) {
    final total = BigInt.from(totalConPropinaCentimos);
    final personas = BigInt.from(cantidadPersonas);
    final cociente = total ~/ personas;
    final resto = total.remainder(personas);
    final parteRedondeada = resto * BigInt.from(2) >= personas
        ? cociente + BigInt.one
        : cociente;

    return parteRedondeada.toInt();
  }
}
