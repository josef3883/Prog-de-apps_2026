import 'package:aplicacion7/data/redondeo_exacto.dart';
import 'package:aplicacion7/data/redondeo_hacia_arriba.dart';
import 'package:aplicacion7/domain/calcular_division.dart';
import 'package:aplicacion7/domain/cuenta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculadora = CalcularDivision();

  test('divide una cuenta de 100.00 entre cuatro con 10 %', () {
    final resultado = calculadora.calcular(
      const Cuenta(
        montoCentimos: 10000,
        cantidadPersonas: 4,
        propinaPuntosBasicos: 1000,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersonaCentimos, 2750);
  });

  test('divide 90.00 entre tres sin propina', () {
    final resultado = calculadora.calcular(
      const Cuenta(
        montoCentimos: 9000,
        cantidadPersonas: 3,
        propinaPuntosBasicos: 0,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersonaCentimos, 3000);
  });

  test('redondea al centimo en modo exacto', () {
    final resultado = calculadora.calcular(
      const Cuenta(
        montoCentimos: 1000,
        cantidadPersonas: 3,
        propinaPuntosBasicos: 0,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersonaCentimos, 333);
  });

  test('redondea hacia arriba al entero siguiente', () {
    final resultado = calculadora.calcular(
      const Cuenta(
        montoCentimos: 1000,
        cantidadPersonas: 3,
        propinaPuntosBasicos: 0,
      ),
      const RedondeoHaciaArriba(),
    );

    expect(resultado.importePorPersonaCentimos, 400);
  });

  test('redondea un empate de medio centimo hacia arriba', () {
    final resultado = calculadora.calcular(
      const Cuenta(
        montoCentimos: 1,
        cantidadPersonas: 2,
        propinaPuntosBasicos: 0,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.importePorPersonaCentimos, 1);
  });

  test('redondea hacia arriba una propina de medio centimo', () {
    final resultado = calculadora.calcular(
      const Cuenta(
        montoCentimos: 100,
        cantidadPersonas: 1,
        propinaPuntosBasicos: 50,
      ),
      const RedondeoExacto(),
    );

    expect(resultado.propinaCentimos, 1);
    expect(resultado.importePorPersonaCentimos, 101);
  });
}
