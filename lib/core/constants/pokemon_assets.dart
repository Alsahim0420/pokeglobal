/// Mapa nombre del Pokémon (slug, minúsculas) → ruta del PNG local.
/// La API devuelve [name] (ej. "pikachu"); se usa para resolver el asset.
/// Para añadir un Pokémon: 1) agregar {nombre}.png en assets/pokemon/,
/// 2) agregar la entrada aquí. En pubspec: [assets/pokemon/].
abstract final class PokemonAssets {
  PokemonAssets._();

  static const String _base = 'assets/pokemon';

  /// Mapa nombre → path del PNG. Evita errores si falta el asset.
  static const Map<String, String> paths = {
    'aggron': '$_base/aggron.png',
    'beedrill': '$_base/beedrill.png',
    'blastoise': '$_base/blastoise.png',
    'bulbasaur': '$_base/bulbasaur.png',
    'chandelure': '$_base/chandelure.png',
    'charizard': '$_base/charizard.png',
    'charmander': '$_base/charmander.png',
    'charmeleon': '$_base/charmeleon.png',
    'clefairy': '$_base/clefairy.png',
    'cubchoo': '$_base/cubchoo.png',
    'dugtrio': '$_base/dugtrio.png',
    'ivysaur': '$_base/ivysaur.png',
    'koffing': '$_base/koffing.png',
    'lickitung': '$_base/lickitung.png',
    'lucario': '$_base/lucario.png',
    'mew': '$_base/mew.png',
    'onix': '$_base/onix.png',
    'pikachu': '$_base/pikachu.png',
    'rayquaza': '$_base/rayquaza.png',
    'serperior': '$_base/serperior.png',
    'squirtle': '$_base/squirtle.png',
    'suicune': '$_base/suicune.png',
    'toucannon': '$_base/toucannon.png',
    'venusaur': '$_base/venusaur.png',
    'wartortle': '$_base/wartortle.png',
    'zoroark': '$_base/zoroark.png',
  };

  /// Ruta del PNG para [name]. Se normaliza con toLowerCase y trim.
  static String? path(String name) {
    final key = name.toLowerCase().trim();
    return paths[key];
  }
}
