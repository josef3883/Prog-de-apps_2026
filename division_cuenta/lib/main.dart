import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  runApp(crearAplicacion());
}

Widget crearAplicacion() {
  final opcionesRedondeo = [
    const OpcionRedondeo(etiqueta: 'Exacto', estrategia: RedondeoExacto()),
    const OpcionRedondeo(
      etiqueta: 'Hacia arriba',
      estrategia: RedondeoHaciaArriba(),
    ),
  ];

  final controller = DivisorController(
    validarEntrada: const ValidarEntrada(),
    calcularDivision: const CalcularDivision(),
    opcionesRedondeo: opcionesRedondeo,
  );

  return AplicacionCuenta(
    divisorController: controller,
    formateadorMoneda: const FormateadorMoneda(),
  );
}

class AplicacionCuenta extends StatelessWidget {
  const AplicacionCuenta({
    super.key,
    required this.divisorController,
    required this.formateadorMoneda,
  });

  final DivisorController divisorController;
  final FormateadorMoneda formateadorMoneda;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuenta clara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174C3C),
          surface: const Color(0xFFF4F5EF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F5EF),
      ),
      home: PantallaDivisor(
        controller: divisorController,
        formateadorMoneda: formateadorMoneda,
      ),
    );
  }
}
