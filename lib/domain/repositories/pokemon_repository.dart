import 'package:pokeglobal/models/pokemon_card_item.dart';

/// Contrato del repositorio de Pokémon (capa domain).
abstract interface class PokemonRepository {
  /// Lista paginada de Pokémon para la Pokedex.
  /// [limit] y [offset] para paginación (estilo PokeAPI).
  Future<List<PokemonCardItem>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });
}
