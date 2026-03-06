/// Entidad de dominio: detalle de un Pokémon para la pantalla de detalle.
/// Independiente de la API; la capa data se encarga del mapeo.
class PokemonDetail {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.number,
    required this.typeLabels,
    required this.description,
    required this.weightKg,
    required this.heightM,
    required this.category,
    required this.ability,
    required this.genderMalePercent,
    required this.genderFemalePercent,
    required this.weaknessLabels,
    required this.spriteUrl,
    required this.nameSlug,
  });

  final int id;
  final String name;
  final String number;
  final List<String> typeLabels;
  final String description;
  final double weightKg;
  final double heightM;
  final String category;
  final String ability;
  final double genderMalePercent;
  final double genderFemalePercent;
  final List<String> weaknessLabels;
  final String spriteUrl;
  final String nameSlug;
}
