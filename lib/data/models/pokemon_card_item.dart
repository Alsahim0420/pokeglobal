/// Modelo para una fila de la lista Pokedex (tarjeta).
class PokemonCardItem {
  const PokemonCardItem({
    required this.id,
    required this.number,
    required this.name,
    required this.nameSlug,
    required this.types,
    required this.spriteUrl,
    this.isFavorite = false,
  });

  final int id;
  final String number;
  final String name;
  /// Nombre en la API (minúsculas, ej. "pikachu") para resolver assets por nombre.
  final String nameSlug;
  final List<PokemonTypeTag> types;
  final String spriteUrl;
  final bool isFavorite;

  PokemonCardItem copyWith({
    List<PokemonTypeTag>? types,
    bool? isFavorite,
  }) {
    return PokemonCardItem(
      id: id,
      number: number,
      name: name,
      nameSlug: nameSlug,
      types: types ?? this.types,
      spriteUrl: spriteUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class PokemonTypeTag {
  const PokemonTypeTag({required this.label});
  final String label;
}
