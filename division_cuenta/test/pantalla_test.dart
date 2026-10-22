import 'package:aplicacion7/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calcula 100, 4 personas y 10% y muestra 27.50', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(crearAplicacion());

    await tester.enterText(find.byKey(const Key('bill-amount')), '100');
    await tester.enterText(find.byKey(const Key('people-count')), '4');
    await tester.enterText(find.byKey(const Key('tip-percent')), '10');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('27.50'), findsOneWidget);
  });

  testWidgets('con 0 personas muestra error y oculta resultado', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(crearAplicacion());

    await tester.enterText(find.byKey(const Key('bill-amount')), '50');
    await tester.enterText(find.byKey(const Key('people-count')), '0');
    await tester.enterText(find.byKey(const Key('tip-percent')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.text('25.00'), findsNothing);
  });

  testWidgets('monto inválido muestra error', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(crearAplicacion());

    await tester.enterText(find.byKey(const Key('bill-amount')), 'abc');
    await tester.enterText(find.byKey(const Key('people-count')), '2');
    await tester.enterText(find.byKey(const Key('tip-percent')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
