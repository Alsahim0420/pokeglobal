import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';

void main() {
  group('PokemonListResponseDto.fromJson', () {
    test('parsea respuesta mínima con count y results', () {
      final json = {
        'count': 100,
        'results': [
          {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
          {'name': 'ivysaur', 'url': 'https://pokeapi.co/api/v2/pokemon/2/'},
        ],
      };
      final dto = PokemonListResponseDto.fromJson(json);
      expect(dto.count, 100);
      expect(dto.results.length, 2);
      expect(dto.results[0].name, 'bulbasaur');
      expect(dto.results[0].url, 'https://pokeapi.co/api/v2/pokemon/1/');
      expect(dto.results[0].id, 1);
      expect(dto.results[1].id, 2);
    });

    test('extrae next y previous', () {
      final json = {
        'count': 20,
        'next': 'https://api?offset=20',
        'previous': null,
        'results': [],
      };
      final dto = PokemonListResponseDto.fromJson(json);
      expect(dto.next, 'https://api?offset=20');
      expect(dto.previous, isNull);
    });

    test('defaults cuando falta todo', () {
      final dto = PokemonListResponseDto.fromJson({});
      expect(dto.count, 0);
      expect(dto.next, isNull);
      expect(dto.previous, isNull);
      expect(dto.results, isEmpty);
    });
  });

  group('PokemonListItemDto.id', () {
    test('extrae id de la URL con barra final', () {
      const dto = PokemonListItemDto(name: 'pikachu', url: 'https://pokeapi.co/api/v2/pokemon/25/');
      expect(dto.id, 25);
    });

    test('extrae id de la URL sin barra final', () {
      const dto = PokemonListItemDto(name: 'pikachu', url: 'https://pokeapi.co/api/v2/pokemon/25');
      expect(dto.id, 25);
    });

    test('devuelve 0 cuando URL inválida', () {
      const dto = PokemonListItemDto(name: 'x', url: '');
      expect(dto.id, 0);
    });
  });
}
