/// Mapeo nombre de tipo desde PokeAPI (inglés) → etiqueta para UI (español).
/// Única fuente de verdad para traducción tipo API → display.
abstract final class PokemonTypeLabelMapper {
  PokemonTypeLabelMapper._();

  static const Map<String, String> _apiToDisplay = {
    'normal': 'Normal',
    'fire': 'Fuego',
    'water': 'Agua',
    'electric': 'Eléctrico',
    'grass': 'Planta',
    'ice': 'Hielo',
    'fighting': 'Lucha',
    'poison': 'Veneno',
    'ground': 'Tierra',
    'flying': 'Volador',
    'psychic': 'Psíquico',
    'bug': 'Bicho',
    'rock': 'Roca',
    'ghost': 'Fantasma',
    'dragon': 'Dragón',
    'dark': 'Siniestro',
    'steel': 'Acero',
    'fairy': 'Hada',
  };

  /// Convierte el nombre del tipo que devuelve la API al label para mostrar.
  static String toDisplayLabel(String apiTypeName) {
    final key = apiTypeName.toLowerCase();
    return _apiToDisplay[key] ?? apiTypeName;
  }

  /// Convierte una lista de nombres API a labels para UI (orden preservado).
  static List<String> toDisplayLabels(List<String> apiTypeNames) {
    return apiTypeNames.map(toDisplayLabel).toList();
  }
}
