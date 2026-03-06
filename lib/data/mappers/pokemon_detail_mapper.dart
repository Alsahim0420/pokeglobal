import 'package:pokeglobal/core/constants/pokemon_type_weakness.dart';
import 'package:pokeglobal/core/env/app_env.dart';
import 'package:pokeglobal/core/services/pokemon_type_label_mapper.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';

/// Mapea DTOs de API → entidad [PokemonDetail]. Una sola responsabilidad (SRP).
class PokemonDetailMapper {
  PokemonDetailMapper._();

  /// Convierte DTO de pokemon + species en entidad de dominio.
  static PokemonDetail toEntity(
    PokemonDetailDto dto,
    PokemonSpeciesDto? species,
  ) {
    final typeLabels = PokemonTypeLabelMapper.toDisplayLabels(dto.typeNames);
    final weaknessLabels = PokemonTypeLabelMapper.toDisplayLabels(
      PokemonTypeWeakness.weaknessApiNames(dto.typeNames),
    );
    final (malePct, femalePct) = _genderFromRate(species?.genderRate ?? -1);
    final displayName = dto.name.isNotEmpty
        ? '${dto.name[0].toUpperCase()}${dto.name.substring(1)}'
        : dto.name;

    return PokemonDetail(
      id: dto.id,
      name: displayName,
      number: 'N°${dto.id.toString().padLeft(3, '0')}',
      typeLabels: typeLabels,
      description: species?.flavorText ?? '',
      weightKg: dto.weightHg / 10,
      heightM: dto.heightDm / 10,
      category: _categoryFromId(dto.id),
      ability: dto.abilityNames.isNotEmpty
          ? _capitalize(dto.abilityNames.first)
          : '',
      genderMalePercent: malePct,
      genderFemalePercent: femalePct,
      weaknessLabels: weaknessLabels,
      spriteUrl: '${AppEnv.spriteBaseUrl}/${dto.id}.png',
      nameSlug: dto.name,
    );
  }

  static (double, double) _genderFromRate(int genderRate) {
    if (genderRate < 0) return (0, 0);
    final femalePct = (genderRate / 8) * 100;
    final malePct = 100 - femalePct;
    return (malePct, femalePct);
  }

  static String _categoryFromId(int id) {
    // La API no da categoría en /pokemon; se puede obtener de species.genera.
    // Por simplicidad devolvemos un placeholder o "Pokémon".
    return 'Pokémon';
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }
}
