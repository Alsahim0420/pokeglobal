import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/data/models/pokemon_list_result.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';

/// Repositorio falso para tests de UI (no llama a la API).
class FakePokemonRepository implements PokemonRepository {
  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  }) async =>
      PokemonListResult(
        list: [
          const PokemonCardItem(
            id: 1,
            number: 'N°001',
            name: 'Bulbasaur',
            nameSlug: 'bulbasaur',
            types: [PokemonTypeTag(label: 'fire')],
            spriteUrl: 'https://example.com/1.png',
            isFavorite: false,
          ),
        ],
        totalCount: 1,
      );

  @override
  Future<List<PokemonCardItem>> enrichPokemonList(List<PokemonCardItem> items) async =>
      items;

  @override
  Future<PokemonDetail> getPokemonDetail(String name) async =>
      PokemonDetail(
        id: 1,
        name: 'Test',
        number: 'N°001',
        typeLabels: const ['fire'],
        description: 'Desc',
        weightKg: 6.5,
        heightM: 0.7,
        category: 'Seed',
        ability: 'Overgrow',
        genderMalePercent: 50,
        genderFemalePercent: 50,
        weaknessLabels: const ['water', 'flying'],
        spriteUrl: 'https://example.com/sprite.png',
        nameSlug: name,
      );

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(List<String> typeApiNames) async =>
      [];
}

/// Repositorio que falla en getPokemonDetail (para tests de estado de error).
class FailingPokemonRepository implements PokemonRepository {
  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  }) async =>
      const PokemonListResult(list: [], totalCount: 0);

  @override
  Future<List<PokemonCardItem>> enrichPokemonList(List<PokemonCardItem> items) async =>
      items;

  @override
  Future<PokemonDetail> getPokemonDetail(String name) async =>
      throw Exception('Network error');

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(List<String> typeApiNames) async =>
      [];
}
