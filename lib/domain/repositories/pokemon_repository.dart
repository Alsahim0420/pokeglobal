import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';
import 'package:pokeglobal/models/pokemon_list_result.dart';

/// Contrato del repositorio de Pokémon (capa domain).
abstract interface class PokemonRepository {
  /// Lista paginada de Pokémon para la Pokedex. Incluye [totalCount] para infinite scroll.
  /// Si [enrich] es false, no se obtienen los tipos (más rápido, útil para búsqueda global).
  Future<PokemonListResult> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool enrich = true,
  });

  /// Enriquece una lista de ítems con sus tipos (para colores en búsqueda global).
  Future<List<PokemonCardItem>> enrichPokemonList(List<PokemonCardItem> items);

  /// Detalle de un Pokémon por nombre (slug). Falla si no existe.
  Future<PokemonDetail> getPokemonDetail(String name);

  /// Lista de Pokémon que pertenecen a alguno de los tipos indicados (labels en español).
  /// Usa la API /type/{name} para obtener todos los Pokémon de cada tipo.
  Future<List<PokemonCardItem>> getPokemonListByTypes(List<String> displayTypeLabels);
}
