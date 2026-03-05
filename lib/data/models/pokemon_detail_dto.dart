/// DTO de GET /pokemon/{id} o GET /pokemon/{name}.
/// Usado por el enricher (solo typeNames) y por la pantalla de detalle (todos los campos).
class PokemonDetailDto {
  const PokemonDetailDto({
    required this.id,
    required this.name,
    required this.typeNames,
    required this.weightHg,
    required this.heightDm,
    required this.abilityNames,
    required this.speciesUrl,
  });

  factory PokemonDetailDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    final name = (json['name'] as String? ?? '').toLowerCase();
    final typesList = json['types'] as List<dynamic>? ?? [];
    final typeNames = <String>[];
    for (final e in typesList) {
      final map = e as Map<String, dynamic>?;
      final type = map?['type'] as Map<String, dynamic>?;
      final typeName = type?['name'] as String?;
      if (typeName != null && typeName.isNotEmpty) {
        typeNames.add(typeName);
      }
    }
    final weightHg = json['weight'] as int? ?? 0;
    final heightDm = json['height'] as int? ?? 0;
    final abilitiesList = json['abilities'] as List<dynamic>? ?? [];
    final abilityNames = <String>[];
    for (final e in abilitiesList) {
      final map = e as Map<String, dynamic>?;
      final ability = map?['ability'] as Map<String, dynamic>?;
      final abilityName = ability?['name'] as String?;
      if (abilityName != null && abilityName.isNotEmpty) {
        abilityNames.add(abilityName);
      }
    }
    final species = json['species'] as Map<String, dynamic>?;
    final speciesUrl = species?['url'] as String? ?? '';

    return PokemonDetailDto(
      id: id,
      name: name,
      typeNames: typeNames,
      weightHg: weightHg,
      heightDm: heightDm,
      abilityNames: abilityNames,
      speciesUrl: speciesUrl,
    );
  }

  final int id;
  final String name;
  final List<String> typeNames;
  final int weightHg;
  final int heightDm;
  final List<String> abilityNames;
  final String speciesUrl;

  /// Id de especie extraído de [speciesUrl] (ej. "https://.../pokemon-species/1/" → 1).
  int get speciesId {
    final segments = speciesUrl.replaceFirst(RegExp(r'/$'), '').split('/');
    final last = segments.isNotEmpty ? segments.last : '';
    return int.tryParse(last) ?? 0;
  }
}
