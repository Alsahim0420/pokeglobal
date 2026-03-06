import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokeglobal/core/storage/key_value_store.dart';
import 'package:pokeglobal/data/local/hive_box_adapter.dart';
import 'package:pokeglobal/data/local/settings_local_datasource.dart';

const String _settingsBoxName = 'settings';

/// Store de configuración (en producción usa Hive). Override en tests con [InMemoryKeyValueStore].
final settingsStoreProvider = Provider<KeyValueStore>((ref) {
  return HiveBoxAdapter(Hive.box<dynamic>(_settingsBoxName));
});

final settingsDatasourceProvider = Provider<SettingsLocalDatasource>((ref) {
  return SettingsLocalDatasource(ref.watch(settingsStoreProvider));
});

/// Modo de tema: light, dark, system.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final ds = ref.read(settingsDatasourceProvider);
    final raw = ds.getThemeMode();
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final ds = ref.read(settingsDatasourceProvider);
    final raw = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await ds.setThemeMode(raw);
    state = mode;
  }
}

/// Idioma actual (es, en, etc.). Null = sistema.
final localeProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final ds = ref.read(settingsDatasourceProvider);
    final code = ds.getLocale();
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    final ds = ref.read(settingsDatasourceProvider);
    await ds.setLocale(locale?.languageCode);
    state = locale;
  }
}
