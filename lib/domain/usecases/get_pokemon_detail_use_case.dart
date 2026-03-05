import 'package:pokeglobal/core/use_case/use_case.dart';
import 'package:pokeglobal/core/use_case/use_case_response.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';

/// Parámetros para obtener el detalle de un Pokémon por nombre.
class GetPokemonDetailParams {
  const GetPokemonDetailParams(this.name);

  final String name;
}

/// Caso de uso: obtiene el detalle de un Pokémon por nombre (slug).
class GetPokemonDetailUseCase
    implements UseCase<PokemonDetail, GetPokemonDetailParams> {
  GetPokemonDetailUseCase(this._repository);

  final PokemonRepository _repository;

  @override
  Future<UseCaseResponse<PokemonDetail>> call(
    GetPokemonDetailParams params,
  ) async {
    try {
      final detail = await _repository.getPokemonDetail(params.name);
      return UseCaseResponse.success(detail);
    } catch (e) {
      return UseCaseResponse.failure(
        e.toString(),
        error: e,
      );
    }
  }
}
