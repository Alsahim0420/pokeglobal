import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/constants/pokemon_type_weakness.dart';

void main() {
  group('PokemonTypeWeakness.weaknessApiNames', () {
    test('devuelve debilidades de un tipo', () {
      expect(
        PokemonTypeWeakness.weaknessApiNames(['grass']),
        containsAll(['fire', 'ice', 'poison', 'flying', 'bug']),
      );
    });

    test('combina debilidades de varios tipos sin duplicados', () {
      final list = PokemonTypeWeakness.weaknessApiNames(['grass', 'poison']);
      expect(list.length, list.toSet().length);
      expect(list, contains('fire'));
      expect(list, contains('psychic'));
    });

    test('lista vacía devuelve vacío', () {
      expect(PokemonTypeWeakness.weaknessApiNames([]), isEmpty);
    });

    test('tipo desconocido no añade nada', () {
      expect(PokemonTypeWeakness.weaknessApiNames(['unknown']), isEmpty);
    });
  });
}
