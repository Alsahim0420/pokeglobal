import 'package:pokeglobal/core/storage/key_value_store.dart';

/// Persistencia de tema e idioma.
class SettingsLocalDatasource {
  SettingsLocalDatasource(this._store);

  static const String _keyThemeMode = 'theme_mode'; // light, dark, system
  static const String _keyLocale = 'locale'; // es, en

  final KeyValueStore _store;

  String getThemeMode() => _store.get(_keyThemeMode) as String? ?? 'system';

  Future<void> setThemeMode(String value) => _store.put(_keyThemeMode, value);

  String? getLocale() => _store.get(_keyLocale) as String?;

  Future<void> setLocale(String? languageCode) {
    if (languageCode == null) return _store.delete(_keyLocale);
    return _store.put(_keyLocale, languageCode);
  }
}
