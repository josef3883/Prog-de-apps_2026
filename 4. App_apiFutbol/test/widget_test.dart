import 'package:flutter_test/flutter_test.dart';

import 'package:app_api_futbol/main.dart';

void main() {
  testWidgets('muestra la pantalla principal de fútbol', (tester) async {
    await tester.pumpWidget(const FootballApp());

    expect(find.text('Fútbol en vivo'), findsOneWidget);
    expect(find.text('Próximos partidos'), findsOneWidget);
    expect(find.byType(MatchesPage), findsOneWidget);
  });
}
