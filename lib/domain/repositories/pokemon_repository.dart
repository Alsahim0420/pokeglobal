import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/models/pokemon_list_result.dart';

/// Contrato del repositorio de Pokémon (capa domain).
abstract interface class PokemonRepository {
  /// Lista paginada de Pokémon para la Pokedex. Incluye [totalCount] para infinite scroll.
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  /// Detalle de un Pokémon por nombre (slug). Falla si no existe.
  Future<PokemonDetail> getPokemonDetail(String name);
}
