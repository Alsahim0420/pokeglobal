import 'package:pokeglobal/data/models/pokemon_card_item.dart';

/// Resultado paginado de la lista de Pokémon (lista + total de la API).
class PokemonListResult {
  const PokemonListResult({required this.list, required this.totalCount});

  final List<PokemonCardItem> list;
  final int totalCount;
}
