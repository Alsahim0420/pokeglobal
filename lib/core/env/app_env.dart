import 'package:flutter/services.dart' show rootBundle;

/// Configuración cargada desde el .env (asset) en tiempo de ejecución.
/// Llama a [AppEnv.init] en main() antes de [runApp].
class AppEnv {
  AppEnv._();

  static Map<String, String>? _env;

  static const String _defaultPokeApiBaseUrl = 'https://pokeapi.co/api/v2';
  static const String _defaultSpriteBaseUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';

  /// Carga el .env desde assets. Llamar en main() antes de runApp.
  static Future<void> init() async {
    try {
      final content = await rootBundle.loadString('.env');
      _env = _parseEnv(content);
    } catch (_) {
      _env = {};
    }
  }

  static Map<String, String> _parseEnv(String content) {
    final map = <String, String>{};
    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final idx = trimmed.indexOf('=');
      if (idx <= 0) continue;
      final key = trimmed.substring(0, idx).trim();
      final value = trimmed.substring(idx + 1).trim();
      if (key.isNotEmpty) map[key] = value;
    }
    return map;
  }

  /// Base URL de PokeAPI v2. Debe ser HTTPS (validar con ensureHttps al usarla).
  static String get pokeApiBaseUrl =>
      _env?['POKEAPI_BASE_URL']?.trim() ?? _defaultPokeApiBaseUrl;

  /// Base URL para sprites oficiales de Pokémon.
  static String get spriteBaseUrl =>
      _env?['SPRITE_BASE_URL']?.trim() ?? _defaultSpriteBaseUrl;

  /// Clave opcional de API. No exponer en logs.
  static String? get pokeApiKey {
    final v = _env?['POKEAPI_KEY']?.trim() ?? '';
    return v.isNotEmpty ? v : null;
  }
}
