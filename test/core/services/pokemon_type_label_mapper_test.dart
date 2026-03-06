import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/services/pokemon_type_label_mapper.dart';

void main() {
  group('PokemonTypeLabelMapper', () {
    test('toDisplayLabel convierte api name a label en español', () {
      expect(PokemonTypeLabelMapper.toDisplayLabel('fire'), 'Fuego');
      expect(PokemonTypeLabelMapper.toDisplayLabel('water'), 'Agua');
      expect(PokemonTypeLabelMapper.toDisplayLabel('grass'), 'Planta');
      expect(PokemonTypeLabelMapper.toDisplayLabel('electric'), 'Eléctrico');
      expect(PokemonTypeLabelMapper.toDisplayLabel('normal'), 'Normal');
    });

    test('toDisplayLabel es case insensitive', () {
      expect(PokemonTypeLabelMapper.toDisplayLabel('FIRE'), 'Fuego');
      expect(PokemonTypeLabelMapper.toDisplayLabel('Grass'), 'Planta');
    });

    test('toDisplayLabel devuelve el mismo string para tipo desconocido', () {
      expect(PokemonTypeLabelMapper.toDisplayLabel('unknown'), 'unknown');
    });

    test('toDisplayLabels convierte lista preservando orden', () {
      final labels = PokemonTypeLabelMapper.toDisplayLabels(['fire', 'water', 'grass']);
      expect(labels, ['Fuego', 'Agua', 'Planta']);
    });

    test('toApiName convierte label a nombre API', () {
      expect(PokemonTypeLabelMapper.toApiName('Fuego'), 'fire');
      expect(PokemonTypeLabelMapper.toApiName('Planta'), 'grass');
      expect(PokemonTypeLabelMapper.toApiName('Hada'), 'fairy');
    });

    test('toApiName devuelve null para label desconocido', () {
      expect(PokemonTypeLabelMapper.toApiName('Desconocido'), isNull);
    });

    test('allDisplayLabels devuelve lista ordenada de todos los tipos', () {
      final all = PokemonTypeLabelMapper.allDisplayLabels;
      expect(all, contains('Fuego'));
      expect(all, contains('Agua'));
      expect(all, orderedEquals([...all]..sort()));
    });
  });
}
