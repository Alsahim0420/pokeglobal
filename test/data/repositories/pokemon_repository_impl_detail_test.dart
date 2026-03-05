import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';

void main() {
  group('PokemonRepositoryImpl.getPokemonDetail', () {
    late PokemonRepositoryImpl repo;
    late FakeRemoteDatasource fakeRemote;

    setUp(() {
      fakeRemote = FakeRemoteDatasource();
      final enricher = PokemonListEnricher(fakeRemote);
      repo = PokemonRepositoryImpl(fakeRemote, enricher);
    });

    test('devuelve entidad mapeada cuando remote devuelve dto y species', () async {
      fakeRemote.detailDto = const PokemonDetailDto(
        id: 1,
        name: 'bulbasaur',
        typeNames: ['grass', 'poison'],
        weightHg: 69,
        heightDm: 7,
        abilityNames: ['overgrow'],
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/1/',
      );
      fakeRemote.speciesDto = const PokemonSpeciesDto(
        flavorText: 'Semilla en la espalda.',
        genderRate: 1,
      );

      final detail = await repo.getPokemonDetail('bulbasaur');

      expect(detail, isA<PokemonDetail>());
      expect(detail.id, 1);
      expect(detail.name, 'Bulbasaur');
      expect(detail.typeLabels, ['Planta', 'Veneno']);
      expect(detail.description, 'Semilla en la espalda.');
      expect(detail.genderMalePercent, 87.5);
    });

    test('devuelve entidad sin descripción cuando species falla', () async {
      fakeRemote.detailDto = const PokemonDetailDto(
        id: 4,
        name: 'charmander',
        typeNames: ['fire'],
        weightHg: 85,
        heightDm: 6,
        abilityNames: ['blaze'],
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/4/',
      );
      fakeRemote.speciesThrows = true;

      final detail = await repo.getPokemonDetail('charmander');

      expect(detail.description, '');
      expect(detail.name, 'Charmander');
    });
  });
}

/// Fake que devuelve DTOs fijos para no llamar a la API en tests.
class FakeRemoteDatasource extends PokemonRemoteDatasource {
  FakeRemoteDatasource() : super(Dio());

  PokemonDetailDto? detailDto;
  PokemonSpeciesDto? speciesDto;
  bool speciesThrows = false;

  @override
  Future<PokemonDetailDto> getPokemonDetailByName(String name) async {
    if (detailDto == null) throw Exception('No dto set');
    return detailDto!;
  }

  @override
  Future<PokemonSpeciesDto> getPokemonSpecies(int id) async {
    if (speciesThrows) throw Exception('Network error');
    if (speciesDto == null) throw Exception('No species set');
    return speciesDto!;
  }
}
