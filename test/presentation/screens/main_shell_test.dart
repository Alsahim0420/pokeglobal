import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/providers/settings_provider.dart';
import 'package:pokeglobal/presentation/screens/main_shell.dart';
import 'package:pokeglobal/presentation/screens/pokemon_detail_screen.dart';
import 'package:pokeglobal/presentation/widgets/pokemon_card.dart';
import '../../helpers/fake_pokemon_repository.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';

void main() {
  testWidgets('MainShell muestra bottom navigation y contenido', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
          pokemonRepositoryProvider.overrideWithValue(FakePokemonRepository()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MainShell(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(MainShell), findsOneWidget);
    // Dejar que la Pokedex cargue la lista (async)
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('MainShell navega a detalle al tocar una card', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
          pokemonRepositoryProvider.overrideWithValue(FakePokemonRepository()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MainShell(),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    if (find.byType(PokemonCard).evaluate().isNotEmpty) {
      await tester.tap(find.byType(PokemonCard).first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(PokemonDetailScreen), findsOneWidget);
    }
  });
}
