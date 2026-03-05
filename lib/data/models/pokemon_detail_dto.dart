/// DTO mínimo de GET /pokemon/{id} para extraer solo los tipos.
/// La API devuelve types: [ { "slot": 1, "type": { "name": "grass", "url": "..." } }, ... ]
class PokemonDetailDto {
  const PokemonDetailDto({required this.typeNames});

  factory PokemonDetailDto.fromJson(Map<String, dynamic> json) {
    final typesList = json['types'] as List<dynamic>? ?? [];
    final typeNames = <String>[];
    for (final e in typesList) {
      final map = e as Map<String, dynamic>?;
      final type = map?['type'] as Map<String, dynamic>?;
      final name = type?['name'] as String?;
      if (name != null && name.isNotEmpty) {
        typeNames.add(name);
      }
    }
    // La API viene ordenada por slot; el primero es el tipo principal.
    return PokemonDetailDto(typeNames: typeNames);
  }

  /// Nombres de tipos en inglés (ej. ["grass", "poison"]). Orden = slot, primero = principal.
  final List<String> typeNames;
}
