// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplicacion7/main.dart';

void main() {
  testWidgets('calcula el reparto en ambos modos', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(crearAplicacion());

    await _calcularYComprobar(
      tester,
      monto: '100.00',
      personas: '4',
      propina: '10',
      modo: 'Exacto',
      esperado: '27.50',
    );
    await _calcularYComprobar(
      tester,
      monto: '90.00',
      personas: '3',
      propina: '0',
      modo: 'Exacto',
      esperado: '30.00',
    );
    await _calcularYComprobar(
      tester,
      monto: '10.00',
      personas: '3',
      propina: '0',
      modo: 'Exacto',
      esperado: '3.33',
    );
    await _calcularYComprobar(
      tester,
      monto: '10,00',
      personas: '3',
      propina: '0',
      modo: 'Hacia arriba',
      esperado: '4.00',
    );
  });
}

Future<void> _calcularYComprobar(
  WidgetTester tester, {
  required String monto,
  required String personas,
  required String propina,
  required String modo,
  required String esperado,
}) async {
  await tester.enterText(find.byKey(const Key('bill-amount')), monto);
  await tester.enterText(find.byKey(const Key('people-count')), personas);
  await tester.enterText(find.byKey(const Key('tip-percent')), propina);
  await tester.tap(find.text(modo));
  await tester.pump();

  final cronometro = Stopwatch()..start();
  await tester.tap(find.text('Calcular'));
  await tester.pumpAndSettle();
  cronometro.stop();

  expect(cronometro.elapsed, lessThan(const Duration(seconds: 1)));
  expect(find.text('Por persona'), findsOneWidget);
  expect(find.text(esperado), findsOneWidget);
}
