import 'package:hive_flutter/hive_flutter.dart';

/// Persistencia de tema e idioma.
class SettingsLocalDatasource {
  SettingsLocalDatasource(this._box);

  static const String _keyThemeMode = 'theme_mode'; // light, dark, system
  static const String _keyLocale = 'locale'; // es, en

  final Box<dynamic> _box;

  String getThemeMode() => _box.get(_keyThemeMode) as String? ?? 'system';

  Future<void> setThemeMode(String value) => _box.put(_keyThemeMode, value);

  String? getLocale() => _box.get(_keyLocale) as String?;

  Future<void> setLocale(String? languageCode) {
    if (languageCode == null) return _box.delete(_keyLocale);
    return _box.put(_keyLocale, languageCode);
  }
}
