import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/core/env/app_env.dart';
import 'package:pokeglobal/core/services/pokemon_type_label_mapper.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/data/mappers/pokemon_detail_mapper.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher_provider.dart';

import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/data/models/pokemon_list_result.dart';

/// Implementación del repositorio de Pokémon. Mapea DTOs a entidades de dominio
/// y enriquece la lista con tipos vía GET /pokemon/{id}.
class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this._remote, this._enricher);

  final PokemonRemoteDatasource _remote;
  final PokemonListEnricher _enricher;

  @override
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  }) async {
    final dto = await _remote.getPokemonList(limit: limit, offset: offset);
    final items = dto.results.map(_toCardItem).toList();
    final list = enrich ? await _enricher.enrich(items) : items;
    return PokemonListResult(list: list, totalCount: dto.count);
  }

  @override
  Future<List<PokemonCardItem>> enrichPokemonList(
      List<PokemonCardItem> items) async {
    return _enricher.enrich(items);
  }

  @override
  Future<List<PokemonCardItem>> getPokemonListByTypes(
      List<String> typeApiNames) async {
    if (typeApiNames.isEmpty) return [];
    final idToName = <int, String>{};
    for (final apiName in typeApiNames) {
      final list = await _remote.getPokemonByType(apiName);
      for (final e in list) {
        idToName[e.id] = e.name;
      }
    }
    final typeTags = typeApiNames
        .map((api) => PokemonTypeTag(
            label: PokemonTypeLabelMapper.toDisplayLabel(api)))
        .toList();
    final sortedIds = idToName.keys.toList()..sort();
    return sortedIds.map((id) {
      final name = idToName[id]!;
      final displayName = name.isNotEmpty
          ? '${name[0].toUpperCase()}${name.substring(1)}'
          : name;
      return PokemonCardItem(
        id: id,
        number: 'N°${id.toString().padLeft(3, '0')}',
        name: displayName,
        nameSlug: name,
        types: typeTags,
        spriteUrl: '${AppEnv.spriteBaseUrl}/$id.png',
        isFavorite: false,
      );
    }).toList();
  }

  @override
  Future<PokemonDetail> getPokemonDetail(String name) async {
    final dto = await _remote.getPokemonDetailByName(name);
    PokemonSpeciesDto? species;
    if (dto.speciesId > 0) {
      try {
        species = await _remote.getPokemonSpecies(dto.speciesId);
      } catch (_) {
        // Si falla species, continuamos sin descripción/género
      }
    }
    return PokemonDetailMapper.toEntity(dto, species);
  }

  PokemonCardItem _toCardItem(PokemonListItemDto item) {
    final id = item.id;
    final name = item.name;
    final displayName = name.isNotEmpty
        ? '${name[0].toUpperCase()}${name.substring(1)}'
        : name;
    final number = 'N°${id.toString().padLeft(3, '0')}';
    final spriteUrl = '${AppEnv.spriteBaseUrl}/$id.png';
    return PokemonCardItem(
      id: id,
      number: number,
      name: displayName,
      nameSlug: name,
      types: const [],
      spriteUrl: spriteUrl,
      isFavorite: false,
    );
  }
}

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  final remote = ref.watch(pokemonRemoteDatasourceProvider);
  final enricher = ref.watch(pokemonListEnricherProvider);
  return PokemonRepositoryImpl(remote, enricher);
});
