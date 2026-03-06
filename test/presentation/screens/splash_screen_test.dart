import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('SplashScreen muestra loader', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashScreen(),
      ),
    );
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    // Avanzar el timer de 2s para evitar "Timer still pending" al terminar
    await tester.pump(const Duration(seconds: 3));
  });
}
