import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';

void main() {
  group('PokemonDetailDto.fromJson', () {
    test('parsea respuesta mínima de PokeAPI /pokemon', () {
      final json = <String, dynamic>{
        'id': 1,
        'name': 'bulbasaur',
        'types': [
          {'type': {'name': 'grass'}},
          {'type': {'name': 'poison'}},
        ],
        'weight': 69,
        'height': 7,
        'abilities': [
          {'ability': {'name': 'overgrow'}},
        ],
        'species': {'url': 'https://pokeapi.co/api/v2/pokemon-species/1/'},
      };

      final dto = PokemonDetailDto.fromJson(json);

      expect(dto.id, 1);
      expect(dto.name, 'bulbasaur');
      expect(dto.typeNames, ['grass', 'poison']);
      expect(dto.weightHg, 69);
      expect(dto.heightDm, 7);
      expect(dto.abilityNames, ['overgrow']);
      expect(dto.speciesUrl, contains('pokemon-species/1'));
      expect(dto.speciesId, 1);
    });

    test('speciesId extrae id de la URL', () {
      expect(
        PokemonDetailDto(
          id: 0,
          name: '',
          typeNames: [],
          weightHg: 0,
          heightDm: 0,
          abilityNames: [],
          speciesUrl: 'https://example.com/pokemon-species/42/',
        ).speciesId,
        42,
      );
    });

    test('maneja campos faltantes con defaults', () {
      final dto = PokemonDetailDto.fromJson(<String, dynamic>{});

      expect(dto.id, 0);
      expect(dto.name, '');
      expect(dto.typeNames, isEmpty);
      expect(dto.weightHg, 0);
      expect(dto.heightDm, 0);
      expect(dto.abilityNames, isEmpty);
      expect(dto.speciesUrl, '');
      expect(dto.speciesId, 0);
    });
  });
}
