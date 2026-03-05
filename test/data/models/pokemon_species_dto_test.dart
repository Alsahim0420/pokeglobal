import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';

void main() {
  group('PokemonSpeciesDto.fromJson', () {
    test('extrae flavor_text en español', () {
      final json = <String, dynamic>{
        'flavor_text_entries': [
          {'language': {'name': 'es'}, 'flavor_text': 'Texto en español.'},
        ],
        'gender_rate': 1,
      };

      final dto = PokemonSpeciesDto.fromJson(json);

      expect(dto.flavorText, 'Texto en español.');
      expect(dto.genderRate, 1);
    });

    test('usa en si no hay es', () {
      final json = <String, dynamic>{
        'flavor_text_entries': [
          {'language': {'name': 'en'}, 'flavor_text': 'English text.'},
        ],
        'gender_rate': 4,
      };

      final dto = PokemonSpeciesDto.fromJson(json);

      expect(dto.flavorText, 'English text.');
      expect(dto.genderRate, 4);
    });

    test('normaliza espacios en flavor_text', () {
      final json = <String, dynamic>{
        'flavor_text_entries': [
          {'language': {'name': 'es'}, 'flavor_text': 'Uno\n\ndos  tres'},
        ],
        'gender_rate': -1,
      };

      final dto = PokemonSpeciesDto.fromJson(json);

      expect(dto.flavorText, 'Uno dos tres');
    });

    test('defaults cuando falta todo', () {
      final dto = PokemonSpeciesDto.fromJson(<String, dynamic>{});

      expect(dto.flavorText, '');
      expect(dto.genderRate, -1);
    });
  });
}
