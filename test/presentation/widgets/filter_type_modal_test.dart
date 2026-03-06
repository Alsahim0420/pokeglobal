import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/widgets/filter_type_modal.dart';
import 'package:pokeglobal/presentation/widgets/primary_button.dart';

void main() {
  testWidgets('showFilterTypeModal abre modal y se cierra con close', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showFilterTypeModal(context),
                child: const Text('Abrir filtro'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir filtro'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('showFilterTypeModal aplica filtro al pulsar Aplicar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showFilterTypeModal(context),
                child: const Text('Abrir filtro'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir filtro'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(find.byType(PrimaryButton), findsNothing);
  });
}
