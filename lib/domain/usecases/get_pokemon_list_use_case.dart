import 'package:pokeglobal/core/use_case/use_case.dart';
import 'package:pokeglobal/core/use_case/use_case_response.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/models/pokemon_list_result.dart';

/// Parámetros para obtener la lista paginada de Pokémon.
class GetPokemonListParams {
  const GetPokemonListParams({
    this.limit = 20,
    this.offset = 0,
    this.enrich = true,
  });

  final int limit;
  final int offset;
  /// Si false, no se enriquecen tipos (más rápido para búsqueda en toda la dex).
  final bool enrich;
}

/// Caso de uso: obtiene la lista paginada de Pokémon desde PokeAPI.
/// Devuelve [list] y [totalCount] para infinite scroll.
class GetPokemonListUseCase
    implements UseCase<PokemonListResult, GetPokemonListParams> {
  GetPokemonListUseCase(this._repository);

  final PokemonRepository _repository;

  @override
  Future<UseCaseResponse<PokemonListResult>> call(
    GetPokemonListParams params,
  ) async {
    try {
      final result = await _repository.getPokemonList(
        limit: params.limit,
        offset: params.offset,
        enrich: params.enrich,
      );
      return UseCaseResponse.success(result);
    } catch (e) {
      return UseCaseResponse.failure(
        e.toString(),
        error: e,
      );
    }
  }
}
