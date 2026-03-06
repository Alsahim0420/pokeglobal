/// Mapa estático: tipo (API name) → tipos que le hacen daño 2x (debilidades).
/// Evita llamadas extra a /type/{id}; una sola fuente de verdad.
abstract final class PokemonTypeWeakness {
  PokemonTypeWeakness._();

  static const Map<String, List<String>> _weaknesses = {
    'normal': ['fighting'],
    'fire': ['water', 'ground', 'rock'],
    'water': ['electric', 'grass'],
    'electric': ['ground'],
    'grass': ['fire', 'ice', 'poison', 'flying', 'bug'],
    'ice': ['fire', 'fighting', 'rock', 'steel'],
    'fighting': ['flying', 'psychic', 'fairy'],
    'poison': ['ground', 'psychic'],
    'ground': ['water', 'grass', 'ice'],
    'flying': ['electric', 'ice', 'rock'],
    'psychic': ['bug', 'ghost', 'dark'],
    'bug': ['fire', 'flying', 'rock'],
    'rock': ['water', 'grass', 'fighting', 'ground', 'steel'],
    'ghost': ['ghost', 'dark'],
    'dragon': ['ice', 'dragon', 'fairy'],
    'dark': ['fighting', 'bug', 'fairy'],
    'steel': ['fire', 'fighting', 'ground'],
    'fairy': ['poison', 'steel'],
  };

  /// Devuelve nombres API de tipos que son debilidad (sin duplicados).
  static List<String> weaknessApiNames(List<String> typeApiNames) {
    final set = <String>{};
    for (final t in typeApiNames) {
      final list = _weaknesses[t.toLowerCase()];
      if (list != null) set.addAll(list);
    }
    return set.toList();
  }
}
