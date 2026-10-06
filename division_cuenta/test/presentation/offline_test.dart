import 'package:aplicacion7/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calcula sin servicios externos y muestra la parte individual', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(crearAplicacion());
    await tester.enterText(find.byKey(const Key('bill-amount')), '90.00');
    await tester.enterText(find.byKey(const Key('people-count')), '3');
    await tester.enterText(find.byKey(const Key('tip-percent')), '0');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Por persona'), findsOneWidget);
    expect(find.text('30.00'), findsOneWidget);
  });
}
