import 'package:pokeglobal/core/use_case/use_case.dart';
import 'package:pokeglobal/core/use_case/use_case_response.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';

/// Parámetros para obtener la lista paginada de Pokémon.
class GetPokemonListParams {
  const GetPokemonListParams({
    this.limit = 20,
    this.offset = 0,
  });

  final int limit;
  final int offset;
}

/// Caso de uso: obtiene la lista de Pokémon desde PokeAPI.
/// Devuelve [UseCaseResponse<List<PokemonCardItem>>].
class GetPokemonListUseCase
    implements UseCase<List<PokemonCardItem>, GetPokemonListParams> {
  GetPokemonListUseCase(this._repository);

  final PokemonRepository _repository;

  @override
  Future<UseCaseResponse<List<PokemonCardItem>>> call(
    GetPokemonListParams params,
  ) async {
    try {
      final list = await _repository.getPokemonList(
        limit: params.limit,
        offset: params.offset,
      );
      return UseCaseResponse.success(list);
    } catch (e) {
      return UseCaseResponse.failure(
        e.toString(),
        error: e,
      );
    }
  }
}
