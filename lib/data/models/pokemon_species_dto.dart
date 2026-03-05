/// DTO de GET /pokemon-species/{id} para descripción y género.
class PokemonSpeciesDto {
  const PokemonSpeciesDto({
    required this.flavorText,
    required this.genderRate,
  });

  factory PokemonSpeciesDto.fromJson(Map<String, dynamic> json) {
    final entries = json['flavor_text_entries'] as List<dynamic>? ?? [];
    String flavorText = '';
    for (final e in entries) {
      final map = e as Map<String, dynamic>?;
      final lang = map?['language'] as Map<String, dynamic>?;
      final code = lang?['name'] as String?;
      if (code == 'es' || (code == 'en' && flavorText.isEmpty)) {
        final text = map?['flavor_text'] as String?;
        if (text != null && text.isNotEmpty) {
          flavorText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
          if (code == 'es') break;
        }
      }
    }
    final genderRate = json['gender_rate'] as int? ?? -1;
    return PokemonSpeciesDto(flavorText: flavorText, genderRate: genderRate);
  }

  final String flavorText;
  /// -1 = genderless, 0 = 0% female, 1 = 12.5% female, ..., 8 = 100% female.
  final int genderRate;
}
