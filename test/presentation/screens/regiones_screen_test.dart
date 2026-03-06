import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/screens/regiones_screen.dart';

void main() {
  testWidgets('RegionesScreen muestra contenido', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const RegionesScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RegionesScreen), findsOneWidget);
  });
}
