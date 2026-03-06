import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokeglobal/core/storage/key_value_store.dart';

/// Adapta un Box de Hive a [KeyValueStore] para uso en producción.
final class HiveBoxAdapter implements KeyValueStore {
  HiveBoxAdapter(this._box);

  final Box<dynamic> _box;

  @override
  dynamic get(String key) => _box.get(key);

  @override
  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }
}
