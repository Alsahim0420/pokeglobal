/// Almacenamiento clave-valor para poder sustituir Hive en tests.
abstract interface class KeyValueStore {
  dynamic get(String key);
  Future<void> put(String key, dynamic value);
  Future<void> delete(String key);
}
