import '../domain/estrategia_redondeo.dart';

class RedondeoHaciaArriba implements EstrategiaRedondeo {
  const RedondeoHaciaArriba();

  @override
  int calcularParte({
    required int totalConPropinaCentimos,
    required int cantidadPersonas,
  }) {
    final total = BigInt.from(totalConPropinaCentimos);
    final personas = BigInt.from(cantidadPersonas);
    final centimosPorUnidad = BigInt.from(100);
    final centimosPorUnidadParaTodos = personas * centimosPorUnidad;
    final unidadesPorPersona =
        (total + centimosPorUnidadParaTodos - BigInt.one) ~/
        centimosPorUnidadParaTodos;

    return (unidadesPorPersona * centimosPorUnidad).toInt();
  }
}
