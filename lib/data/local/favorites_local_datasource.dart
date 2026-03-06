import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Almacenamiento local de favoritos (IDs y slug por id para cargar detalle).
class FavoritesLocalDatasource {
  FavoritesLocalDatasource(this._box);

  static const String _keyIds = 'favorite_ids';
  static const String _keyIdToSlug = 'id_to_slug';

  final Box<dynamic> _box;

  List<int> getFavoriteIds() {
    final raw = _box.get(_keyIds);
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
    final raw = _box.get(_keyIdToSlug);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(int.parse(k), v as String));
    } catch (_) {
      return {};
    }
  }

  Future<void> setFavorites(List<int> ids, Map<int, String> idToSlug) async {
    await _box.put(_keyIds, jsonEncode(ids));
    final encoded = jsonEncode(idToSlug.map((k, v) => MapEntry(k.toString(), v)));
    await _box.put(_keyIdToSlug, encoded);
  }
}
