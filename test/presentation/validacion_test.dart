import 'package:aplicacion7/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final casosInvalidos = <({String campo, String valor, String mensaje})>[
    (campo: 'bill-amount', valor: '', mensaje: 'Monto inválido'),
    (campo: 'bill-amount', valor: '-1.00', mensaje: 'Monto inválido'),
    (campo: 'bill-amount', valor: 'NaN', mensaje: 'Monto inválido'),
    (campo: 'bill-amount', valor: 'Infinity', mensaje: 'Monto inválido'),
    (campo: 'bill-amount', valor: '1,000.00', mensaje: 'Monto inválido'),
    (campo: 'bill-amount', valor: '1.001', mensaje: 'Monto inválido'),
    (
      campo: 'people-count',
      valor: '0',
      mensaje: 'Debe haber al menos una persona',
    ),
    (
      campo: 'people-count',
      valor: '-1',
      mensaje: 'Debe haber al menos una persona',
    ),
    (
      campo: 'people-count',
      valor: '1.5',
      mensaje: 'Número de personas inválido',
    ),
    (
      campo: 'people-count',
      valor: 'abc',
      mensaje: 'Número de personas inválido',
    ),
    (campo: 'tip-percent', valor: '', mensaje: 'Propina inválida'),
    (campo: 'tip-percent', valor: 'NaN', mensaje: 'Propina inválida'),
    (campo: 'tip-percent', valor: 'Infinity', mensaje: 'Propina inválida'),
    (campo: 'tip-percent', valor: '1,000', mensaje: 'Propina inválida'),
    (campo: 'tip-percent', valor: '1.001', mensaje: 'Propina inválida'),
    (campo: 'tip-percent', valor: '100.01', mensaje: 'Propina inválida'),
    (campo: 'tip-percent', valor: 'abc', mensaje: 'Propina inválida'),
  ];

  for (final caso in casosInvalidos) {
    testWidgets('${caso.campo} rechaza "${caso.valor}"', (
      WidgetTester tester,
    ) async {
      await _prepararPantalla(tester);
      await tester.enterText(find.byKey(Key(caso.campo)), caso.valor);
      await tester.tap(find.text('Calcular'));
      await tester.pumpAndSettle();

      expect(find.text(caso.mensaje), findsOneWidget);
      expect(find.byKey(const Key('share-amount')), findsNothing);
    });
  }

  testWidgets('un error oculta el resultado anterior', (
    WidgetTester tester,
  ) async {
    await _prepararPantalla(tester);
    await tester.enterText(find.byKey(const Key('bill-amount')), '50.00');
    await tester.enterText(find.byKey(const Key('people-count')), '2');
    await tester.enterText(find.byKey(const Key('tip-percent')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('25.00'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('bill-amount')), 'abc');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Monto inválido'), findsOneWidget);
    expect(find.byKey(const Key('share-amount')), findsNothing);
  });
}

Future<void> _prepararPantalla(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(crearAplicacion());
  await tester.enterText(find.byKey(const Key('bill-amount')), '50.00');
  await tester.enterText(find.byKey(const Key('people-count')), '2');
  await tester.enterText(find.byKey(const Key('tip-percent')), '0');
}
