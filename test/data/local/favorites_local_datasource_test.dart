import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/data/local/favorites_local_datasource.dart';

void main() {
  group('FavoritesLocalDatasource', () {
    late InMemoryKeyValueStore store;
    late FavoritesLocalDatasource ds;

    setUp(() {
      store = InMemoryKeyValueStore();
      ds = FavoritesLocalDatasource(store);
    });

    test('getFavoriteIds devuelve vacío cuando no hay datos', () {
      expect(ds.getFavoriteIds(), isEmpty);
    });

    test('getFavoriteIds devuelve ids después de setFavorites', () async {
      await ds.setFavorites([1, 2, 3], {1: 'bulbasaur', 2: 'ivysaur', 3: 'venusaur'});
      expect(ds.getFavoriteIds(), [1, 2, 3]);
    });

    test('getIdToSlug devuelve mapa vacío cuando no hay datos', () {
      expect(ds.getIdToSlug(), isEmpty);
    });

    test('getIdToSlug devuelve mapa después de setFavorites', () async {
      await ds.setFavorites([1, 2], {1: 'bulbasaur', 2: 'ivysaur'});
      expect(ds.getIdToSlug(), {1: 'bulbasaur', 2: 'ivysaur'});
    });

    test('getFavoriteIds tolera JSON inválido y devuelve vacío', () async {
      await store.put('favorite_ids', 'not-json');
      expect(ds.getFavoriteIds(), isEmpty);
    });
  });
}
