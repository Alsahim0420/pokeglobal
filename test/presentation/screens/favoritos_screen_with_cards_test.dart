import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/screens/favoritos_screen.dart';
import 'package:pokeglobal/presentation/widgets/pokemon_card.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';
import '../../helpers/fake_pokemon_repository.dart';

void main() {
  testWidgets('FavoritosScreen muestra PokemonCard cuando hay favoritos', (WidgetTester tester) async {
    final store = InMemoryKeyValueStore();
    await store.put('favorite_ids', jsonEncode([1]));
    await store.put('id_to_slug', jsonEncode({'1': 'bulbasaur'}));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoritesStoreProvider.overrideWithValue(store),
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
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(PokemonCard), findsWidgets);
  });
}
