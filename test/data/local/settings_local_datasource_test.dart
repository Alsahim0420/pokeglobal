import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/storage/in_memory_key_value_store.dart';
import 'package:pokeglobal/data/local/settings_local_datasource.dart';

void main() {
  group('SettingsLocalDatasource', () {
    late InMemoryKeyValueStore store;
    late SettingsLocalDatasource ds;

    setUp(() {
      store = InMemoryKeyValueStore();
      ds = SettingsLocalDatasource(store);
    });

    test('getThemeMode devuelve system por defecto', () {
      expect(ds.getThemeMode(), 'system');
    });

    test('setThemeMode y getThemeMode', () async {
      await ds.setThemeMode('dark');
      expect(ds.getThemeMode(), 'dark');
    });

    test('getLocale devuelve null cuando no hay dato', () {
      expect(ds.getLocale(), isNull);
    });

    test('setLocale y getLocale', () async {
      await ds.setLocale('es');
      expect(ds.getLocale(), 'es');
    });

    test('setLocale null borra locale', () async {
      await ds.setLocale('en');
      expect(ds.getLocale(), 'en');
      await ds.setLocale(null);
      expect(ds.getLocale(), isNull);
    });
  });
}
