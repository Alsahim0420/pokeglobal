import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/screens/favoritos_screen.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';
import '../../helpers/fake_pokemon_repository.dart';

void main() {
  testWidgets('FavoritosScreen construye', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
          pokemonRepositoryProvider.overrideWithValue(FakePokemonRepository()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FavoritosScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(FavoritosScreen), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
