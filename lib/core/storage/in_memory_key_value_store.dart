import 'package:pokeglobal/core/storage/key_value_store.dart';

/// Implementación en memoria para tests (sin Hive).
final class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, dynamic> _storage = {};

  @override
  dynamic get(String key) => _storage[key];

  @override
  Future<void> put(String key, dynamic value) async {
    _storage[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }
}
