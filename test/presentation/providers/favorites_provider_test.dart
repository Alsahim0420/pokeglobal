import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';

void main() {
  test('FavoritesNotifier build devuelve vacío por defecto', () async {
    final container = ProviderContainer(
      overrides: [
        favoritesStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(favoriteIdsProvider), isEmpty);
  });

  test('toggle añade id y slug', () async {
    final container = ProviderContainer(
      overrides: [
        favoritesStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(favoriteIdsProvider.notifier).toggle(1, nameSlug: 'bulbasaur');
    expect(container.read(favoriteIdsProvider), {1});
    expect(container.read(favoriteIdsProvider.notifier).slugForId(1), 'bulbasaur');
  });

  test('toggle quita id', () async {
    final container = ProviderContainer(
      overrides: [
        favoritesStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(favoriteIdsProvider.notifier).toggle(1, nameSlug: 'bulbasaur');
    await container.read(favoriteIdsProvider.notifier).toggle(1);
    expect(container.read(favoriteIdsProvider), isEmpty);
    expect(container.read(favoriteIdsProvider.notifier).slugForId(1), isNull);
  });
}
