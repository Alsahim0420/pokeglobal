import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';

void main() {
  group('PokemonCardItem', () {
    test('copyWith actualiza types', () {
      const item = PokemonCardItem(
        id: 1,
        number: 'N°001',
        name: 'Bulbasaur',
        nameSlug: 'bulbasaur',
        types: [PokemonTypeTag(label: 'Planta')],
        spriteUrl: 'https://example.com/1.png',
      );
      final updated = item.copyWith(types: [PokemonTypeTag(label: 'Veneno')]);
      expect(updated.types.length, 1);
      expect(updated.types.first.label, 'Veneno');
      expect(updated.name, 'Bulbasaur');
    });

    test('copyWith actualiza isFavorite', () {
      const item = PokemonCardItem(
        id: 1,
        number: 'N°001',
        name: 'Bulbasaur',
        nameSlug: 'bulbasaur',
        types: [],
        spriteUrl: '',
        isFavorite: false,
      );
      final updated = item.copyWith(isFavorite: true);
      expect(updated.isFavorite, true);
    });

    test('copyWith sin args devuelve igual', () {
      const item = PokemonCardItem(
        id: 1,
        number: 'N°001',
        name: 'B',
        nameSlug: 'b',
        types: [],
        spriteUrl: '',
      );
      final updated = item.copyWith();
      expect(updated.types, item.types);
      expect(updated.isFavorite, item.isFavorite);
    });
  });

  group('PokemonTypeTag', () {
    test('almacena label', () {
      const tag = PokemonTypeTag(label: 'Fuego');
      expect(tag.label, 'Fuego');
    });
  });
}
