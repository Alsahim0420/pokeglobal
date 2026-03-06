import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokeglobal/data/local/favorites_local_datasource.dart';

const String _favoritesBoxName = 'favorites';

/// Inicializa Hive y abre las cajas de favoritos y configuración. Llamar desde main() antes de runApp.
Future<void> initFavoritesStorage() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(_favoritesBoxName);
  await Hive.openBox<dynamic>('settings');
}

/// Caja de favoritos (debe estar abierta en main con [initFavoritesStorage]).
Box<dynamic> get favoritesBox => Hive.box<dynamic>(_favoritesBoxName);

final favoritesBoxProvider = Provider<Box<dynamic>>((ref) => favoritesBox);

final favoritesDatasourceProvider = Provider<FavoritesLocalDatasource>((ref) {
  return FavoritesLocalDatasource(ref.watch(favoritesBoxProvider));
});

/// Estado de favoritos: conjunto de IDs. Persistido en Hive.
class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    final ds = ref.read(favoritesDatasourceProvider);
    return Set<int>.from(ds.getFavoriteIds());
  }

  /// Añade o quita el id de favoritos y guarda el slug para la pantalla Favoritos.
  Future<void> toggle(int id, {String? nameSlug}) async {
    final ds = ref.read(favoritesDatasourceProvider);
    final ids = ds.getFavoriteIds();
    final idToSlug = ds.getIdToSlug();

    final newIds = List<int>.from(ids);
    final contains = newIds.contains(id);
    if (contains) {
      newIds.remove(id);
      idToSlug.remove(id);
    } else {
      newIds.add(id);
      if (nameSlug != null) idToSlug[id] = nameSlug;
    }
    newIds.sort();

    await ds.setFavorites(newIds, idToSlug);
    state = Set<int>.from(newIds);
  }

  /// Devuelve el nameSlug guardado para un id (para cargar detalle en Favoritos).
  String? slugForId(int id) {
    return ref.read(favoritesDatasourceProvider).getIdToSlug()[id];
  }
}

final favoriteIdsProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);
