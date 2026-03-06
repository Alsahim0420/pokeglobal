import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/presentation/providers/settings_provider.dart';

void main() {
  group('ThemeModeNotifier', () {
    test('build devuelve system por defecto', () async {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('setThemeMode actualiza a light', () async {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);
    });

    test('setThemeMode actualiza a dark', () async {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });

  group('LocaleNotifier', () {
    test('build devuelve null por defecto', () async {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(localeProvider), isNull);
    });

    test('setLocale actualiza a es', () async {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(localeProvider.notifier).setLocale(const Locale('es'));
      expect(container.read(localeProvider), const Locale('es'));
    });

    test('setLocale null borra locale', () async {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(localeProvider.notifier).setLocale(const Locale('en'));
      expect(container.read(localeProvider), const Locale('en'));
      await container.read(localeProvider.notifier).setLocale(null);
      expect(container.read(localeProvider), isNull);
    });
  });
}
