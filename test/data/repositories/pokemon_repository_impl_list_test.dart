import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher.dart';

void main() {
  group('PokemonRepositoryImpl.getPokemonList', () {
    late PokemonRepositoryImpl repo;
    late FakeListRemoteDatasource fakeRemote;

    setUp(() {
      fakeRemote = FakeListRemoteDatasource();
      final enricher = PokemonListEnricher(fakeRemote);
      repo = PokemonRepositoryImpl(fakeRemote, enricher);
    });

    test('devuelve lista con totalCount cuando enrich es false', () async {
      fakeRemote.listDto = const PokemonListResponseDto(
        count: 100,
        next: 'https://next',
        previous: null,
        results: [
          PokemonListItemDto(
            name: 'bulbasaur',
            url: 'https://pokeapi.co/api/v2/pokemon/1/',
          ),
          PokemonListItemDto(
            name: 'ivysaur',
            url: 'https://pokeapi.co/api/v2/pokemon/2/',
          ),
        ],
      );

      final result = await repo.getPokemonList(
        limit: 2,
        offset: 0,
        enrich: false,
      );

      expect(result.totalCount, 100);
      expect(result.list.length, 2);
      expect(result.list[0].name, 'Bulbasaur');
      expect(result.list[0].number, 'N°001');
      expect(result.list[0].types, isEmpty);
    });

    test('devuelve lista enriquecida cuando enrich es true', () async {
      fakeRemote.listDto = const PokemonListResponseDto(
        count: 1,
        next: null,
        previous: null,
        results: [
          PokemonListItemDto(
            name: 'bulbasaur',
            url: 'https://pokeapi.co/api/v2/pokemon/1/',
          ),
        ],
      );
      fakeRemote.detailById[1] = const PokemonDetailDto(
        id: 1,
        name: 'bulbasaur',
        typeNames: ['grass', 'poison'],
        weightHg: 69,
        heightDm: 7,
        abilityNames: ['overgrow'],
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/1/',
      );

      final result = await repo.getPokemonList(
        limit: 1,
        offset: 0,
        enrich: true,
      );

      expect(result.list.length, 1);
      expect(result.list[0].types.length, 2);
      expect(result.list[0].types.first.label, 'Planta');
    });
  });

  group('PokemonRepositoryImpl.getPokemonListByTypes', () {
    late PokemonRepositoryImpl repo;
    late FakeListRemoteDatasource fakeRemote;

    setUp(() {
      fakeRemote = FakeListRemoteDatasource();
      final enricher = PokemonListEnricher(fakeRemote);
      repo = PokemonRepositoryImpl(fakeRemote, enricher);
    });

    test('devuelve lista vacía cuando typeApiNames está vacío', () async {
      final result = await repo.getPokemonListByTypes([]);
      expect(result, isEmpty);
    });

    test('devuelve Pokémon del tipo cuando remote devuelve ids', () async {
      fakeRemote.pokemonByType['fire'] = [
        (id: 4, name: 'charmander'),
        (id: 5, name: 'charmeleon'),
      ];

      final result = await repo.getPokemonListByTypes(['fire']);

      expect(result.length, 2);
      expect(result[0].id, 4);
      expect(result[0].name, 'Charmander');
      expect(result[0].nameSlug, 'charmander');
      expect(result[0].types.first.label, 'Fuego');
    });
  });
}

class FakeListRemoteDatasource extends PokemonRemoteDatasource {
  FakeListRemoteDatasource() : super(Dio());

  PokemonListResponseDto? listDto;
  final Map<int, PokemonDetailDto> detailById = {};
  final Map<String, List<({int id, String name})>> pokemonByType = {};

  @override
  Future<PokemonListResponseDto> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    if (listDto == null) throw Exception('No list set');
    return listDto!;
  }

  @override
  Future<PokemonDetailDto> getPokemonDetail(int id) async {
    final dto = detailById[id];
    if (dto == null) throw Exception('No detail for $id');
    return dto;
  }

  @override
  Future<List<({int id, String name})>> getPokemonByType(
    String apiTypeName,
  ) async {
    final list = pokemonByType[apiTypeName] ?? [];
    return list;
  }
}
