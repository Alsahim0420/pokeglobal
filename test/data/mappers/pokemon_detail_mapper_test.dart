import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';
import 'package:pokeglobal/data/mappers/pokemon_detail_mapper.dart';

void main() {
  group('PokemonDetailMapper.toEntity', () {
    test(
      'mapea DTO y species a entidad con tipos y debilidades en español',
      () {
        const dto = PokemonDetailDto(
          id: 1,
          name: 'bulbasaur',
          typeNames: ['grass', 'poison'],
          weightHg: 69,
          heightDm: 7,
          abilityNames: ['overgrow'],
          speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/1/',
        );
        const species = PokemonSpeciesDto(
          flavorText: 'Tiene una semilla en la espalda.',
          genderRate: 1,
        );

        final entity = PokemonDetailMapper.toEntity(dto, species);

        expect(entity.id, 1);
        expect(entity.name, 'Bulbasaur');
        expect(entity.number, 'N°001');
        expect(entity.typeLabels, ['Planta', 'Veneno']);
        expect(entity.description, 'Tiene una semilla en la espalda.');
        expect(entity.weightKg, 6.9);
        expect(entity.heightM, 0.7);
        expect(entity.ability, 'Overgrow');
        expect(entity.category, 'Pokémon');
        expect(entity.genderMalePercent, 87.5);
        expect(entity.genderFemalePercent, 12.5);
        expect(entity.weaknessLabels, contains('Fuego'));
        expect(entity.weaknessLabels, contains('Psíquico'));
        expect(entity.spriteUrl, contains('official-artwork'));
        expect(entity.spriteUrl, endsWith('/1.png'));
        expect(entity.nameSlug, 'bulbasaur');
      },
    );

    test('sin species usa descripción vacía y género 0', () {
      const dto = PokemonDetailDto(
        id: 4,
        name: 'charmander',
        typeNames: ['fire'],
        weightHg: 85,
        heightDm: 6,
        abilityNames: ['blaze'],
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/4/',
      );

      final entity = PokemonDetailMapper.toEntity(dto, null);

      expect(entity.description, '');
      expect(entity.genderMalePercent, 0);
      expect(entity.genderFemalePercent, 0);
      expect(entity.name, 'Charmander');
    });
  });
}
