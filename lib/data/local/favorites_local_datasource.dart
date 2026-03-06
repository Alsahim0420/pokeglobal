import 'dart:convert';

import 'package:pokeglobal/core/storage/key_value_store.dart';

/// Almacenamiento local de favoritos (IDs y slug por id para cargar detalle).
class FavoritesLocalDatasource {
  FavoritesLocalDatasource(this._store);

  static const String _keyIds = 'favorite_ids';
  static const String _keyIdToSlug = 'id_to_slug';

  final KeyValueStore _store;

  List<int> getFavoriteIds() {
    final raw = _store.get(_keyIds);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw as String) as List<dynamic>;
      return list.map((e) => (e as num).toInt()).toList();
    } catch (_) {
      return [];
    }
  }

  /// Mapa id -> nameSlug para cargar detalle en Favoritos.
  Map<int, String> getIdToSlug() {
    final raw = _store.get(_keyIdToSlug);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(int.parse(k), v as String));
    } catch (_) {
      return {};
    }
  }

  Future<void> setFavorites(List<int> ids, Map<int, String> idToSlug) async {
    await _store.put(_keyIds, jsonEncode(ids));
    final encoded = jsonEncode(idToSlug.map((k, v) => MapEntry(k.toString(), v)));
    await _store.put(_keyIdToSlug, encoded);
  }
}
