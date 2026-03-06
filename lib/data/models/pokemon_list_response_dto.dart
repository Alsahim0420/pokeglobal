/// DTO de la respuesta GET https://pokeapi.co/api/v2/pokemon
class PokemonListResponseDto {
  const PokemonListResponseDto({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonListResponseDto.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>? ?? [];
    return PokemonListResponseDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsList
          .map((e) => PokemonListItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItemDto> results;
}

class PokemonListItemDto {
  const PokemonListItemDto({
    required this.name,
    required this.url,
  });

  factory PokemonListItemDto.fromJson(Map<String, dynamic> json) {
    return PokemonListItemDto(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  final String name;
  final String url;

  /// Extrae el id del Pokémon desde la URL (ej. "https://pokeapi.co/api/v2/pokemon/1/" -> 1).
  int get id {
    final segments = url.replaceFirst(RegExp(r'/$'), '').split('/');
    final last = segments.isNotEmpty ? segments.last : '';
    return int.tryParse(last) ?? 0;
  }
}
