import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher_provider.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';

/// URL base para sprites oficiales (PokeAPI).
const String spriteBaseUrl =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';

/// Implementación del repositorio de Pokémon. Mapea DTOs a entidades de dominio
/// y enriquece la lista con tipos vía GET /pokemon/{id}.
class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this._remote, this._enricher);

  final PokemonRemoteDatasource _remote;
  final PokemonListEnricher _enricher;

  @override
  Future<List<PokemonCardItem>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final dto = await _remote.getPokemonList(limit: limit, offset: offset);
    final items = dto.results.map(_toCardItem).toList();
    return _enricher.enrich(items);
  }

  PokemonCardItem _toCardItem(PokemonListItemDto item) {
    final id = item.id;
    final name = item.name;
    final displayName = name.isNotEmpty
        ? '${name[0].toUpperCase()}${name.substring(1)}'
        : name;
    final number = 'N°${id.toString().padLeft(3, '0')}';
    final spriteUrl = '$spriteBaseUrl/$id.png';
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
