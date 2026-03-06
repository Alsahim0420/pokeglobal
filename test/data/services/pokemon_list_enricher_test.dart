import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher.dart';

void main() {
  group('PokemonListEnricher', () {
    test('lista vacía devuelve vacía', () async {
      final ds = _FakeDatasource();
      final enricher = PokemonListEnricher(ds);
      final result = await enricher.enrich([]);
      expect(result, isEmpty);
    });

    test('enriquece un ítem con tipos cuando el datasource devuelve detalle', () async {
      final ds = _FakeDatasource();
      ds.detailById[1] = const PokemonDetailDto(
        id: 1,
        name: 'bulbasaur',
        typeNames: ['grass', 'poison'],
        weightHg: 69,
        heightDm: 7,
        abilityNames: ['overgrow'],
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/1/',
      );
      final enricher = PokemonListEnricher(ds);
      const item = PokemonCardItem(
        id: 1,
        number: 'N°001',
        name: 'Bulbasaur',
        nameSlug: 'bulbasaur',
        types: [],
        spriteUrl: '',
      );
      final result = await enricher.enrich([item]);
      expect(result.length, 1);
      expect(result.first.types.length, 2);
      expect(result.first.types.map((t) => t.label).toList(), ['Planta', 'Veneno']);
    });

    test('deja ítem sin tipos cuando el datasource falla', () async {
      final ds = _FakeDatasource();
      ds.detailThrows = true;
      final enricher = PokemonListEnricher(ds);
      const item = PokemonCardItem(
        id: 99,
        number: 'N°099',
        name: 'X',
        nameSlug: 'x',
        types: [],
        spriteUrl: '',
      );
      final result = await enricher.enrich([item]);
      expect(result.length, 1);
      expect(result.first.types, isEmpty);
    });
  });
}

class _FakeDatasource extends PokemonRemoteDatasource {
  _FakeDatasource() : super(Dio());

  final Map<int, PokemonDetailDto> detailById = {};
  bool detailThrows = false;

  @override
  Future<PokemonDetailDto> getPokemonDetail(int id) async {
    if (detailThrows) throw Exception('Network');
    final dto = detailById[id];
    if (dto == null) throw Exception('Not found');
    return dto;
  }
}
