import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/l10n/type_label_helper.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';

void main() {
  group('type_label_helper', () {
    testWidgets('typeLabel devuelve texto localizado para tipo fire', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (context) {
              final label = typeLabel(context, 'fire');
              return Text(label);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Fuego'), findsOneWidget);
    });

    testWidgets('typeLabel devuelve apiTypeName para tipo desconocido', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final label = typeLabel(context, 'unknown');
              return Text(label);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('unknown'), findsOneWidget);
    });

    test('apiTypeNames contiene los 18 tipos', () {
      expect(apiTypeNames.length, 18);
      expect(apiTypeNames, contains('fire'));
      expect(apiTypeNames, contains('water'));
    });

    testWidgets('typeLabel devuelve etiquetas para todos los tipos en es', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (context) {
              final labels = apiTypeNames.map((api) => typeLabel(context, api)).toList();
              return Text(labels.join(','));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.data, contains('Fuego'));
      expect(text.data, contains('Agua'));
      expect(text.data, contains('Planta'));
    });

    testWidgets('apiNameFromDisplayLabel devuelve api name para label en es', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('es'),
          home: Builder(
            builder: (context) {
              final api = apiNameFromDisplayLabel(context, 'Fuego');
              return Text(api ?? '');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('fire'), findsOneWidget);
    });

    testWidgets('displayLabelInLocale usa idioma del contexto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              final label = displayLabelInLocale(context, 'Fuego');
              return Text(label);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Fire'), findsOneWidget);
    });
  });
}
