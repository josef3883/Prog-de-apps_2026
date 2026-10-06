import 'package:aplicacion7/data/redondeo_exacto.dart';
import 'package:aplicacion7/data/redondeo_hacia_arriba.dart';
import 'package:aplicacion7/domain/calcular_division.dart';
import 'package:aplicacion7/domain/cuenta.dart';
import 'package:aplicacion7/domain/estrategia_redondeo.dart';
import 'package:aplicacion7/domain/validar_entrada.dart';
import 'package:flutter_test/flutter_test.dart';

import 'casos_de_prueba.dart';

void main() {
  for (final caso in casos) {
    test(caso.nombre, () {
      final validacion = const ValidarEntrada().validar(
        monto: _textoNumero(caso.monto),
        personas: caso.personas.toString(),
        propina: _textoNumero(caso.propina),
      );

      if (caso.errorEsperado != null) {
        expect(validacion.cuenta, isNull);
        expect(validacion.error, isNotNull);
        expect(_mensajeError(validacion.error!), equals(caso.errorEsperado));
        return;
      }

      expect(caso.esperado, isNotNull);
      final estrategia = _crearEstrategia(caso.modo);
      final resultado = const CalcularDivision().calcular(
        Cuenta(
          montoCentimos: _centimosDesdeDouble(caso.monto),
          cantidadPersonas: caso.personas,
          propinaPuntosBasicos: _puntosBasicosDesdeDouble(caso.propina),
        ),
        estrategia,
      );

      final valor = resultado.importePorPersonaCentimos / 100;
      expect(valor, closeTo(caso.esperado!, 0.001));
    });
  }

  test('LSP: CalcularDivision recibe estrategias concretas sin if ni cast', () {
    const calculadora = CalcularDivision();
    const cuenta = Cuenta(
      montoCentimos: 1000,
      cantidadPersonas: 3,
      propinaPuntosBasicos: 0,
    );

    final estrategias = <EstrategiaRedondeo>[
      const RedondeoExacto(),
      const RedondeoHaciaArriba(),
    ];

    for (final estrategia in estrategias) {
      final resultado = calculadora.calcular(cuenta, estrategia);
      expect(resultado.importePorPersonaCentimos, isA<int>());
      expect(resultado.importePorPersonaCentimos, greaterThanOrEqualTo(0));
    }

    final exacto = calculadora.calcular(cuenta, const RedondeoExacto());
    final arriba = calculadora.calcular(cuenta, const RedondeoHaciaArriba());

    expect(exacto.importePorPersonaCentimos, 333);
    expect(arriba.importePorPersonaCentimos, 400);
  });
}

String _textoNumero(double valor) {
  if (valor.isNaN || valor.isInfinite) {
    return valor.toString();
  }

  return valor.toStringAsFixed(2);
}

int _centimosDesdeDouble(double valor) {
  return (valor * 100).round();
}

int _puntosBasicosDesdeDouble(double valor) {
  return (valor * 100).round();
}

EstrategiaRedondeo _crearEstrategia(String modo) {
  switch (modo) {
    case 'exacto':
      return const RedondeoExacto();
    case 'arriba':
      return const RedondeoHaciaArriba();
    default:
      throw ArgumentError('Modo desconocido: $modo');
  }
}

String _mensajeError(ErrorValidacion error) => switch (error) {
  ErrorValidacion.montoInvalido => 'Monto inválido',
  ErrorValidacion.debeHaberUnaPersona => 'Debe haber al menos una persona',
  ErrorValidacion.numeroPersonasInvalido => 'Número de personas inválido',
  ErrorValidacion.propinaInvalida => 'Propina inválida',
};
