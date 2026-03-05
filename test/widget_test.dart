// Smoke test: la app arranca sin errores.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/main.dart';

void main() {
  testWidgets('PokeGlobalApp builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PokeGlobalApp()));
    await tester.pump();
    expect(find.byType(PokeGlobalApp), findsOneWidget);
  });
}
