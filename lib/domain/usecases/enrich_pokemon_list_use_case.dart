import 'package:pokeglobal/core/use_case/use_case.dart';
import 'package:pokeglobal/core/use_case/use_case_response.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';

/// Parámetros para enriquecer una lista con tipos.
class EnrichPokemonListParams {
  const EnrichPokemonListParams({required this.items});

  final List<PokemonCardItem> items;
}

/// Enriquece una lista de [PokemonCardItem] con tipos (colores en cards).
class EnrichPokemonListUseCase
    implements UseCase<List<PokemonCardItem>, EnrichPokemonListParams> {
  EnrichPokemonListUseCase(this._repository);

  final PokemonRepository _repository;

  @override
  Future<UseCaseResponse<List<PokemonCardItem>>> call(
    EnrichPokemonListParams params,
  ) async {
    try {
      final list = await _repository.enrichPokemonList(params.items);
      return UseCaseResponse.success(list);
    } catch (e) {
      return UseCaseResponse.failure(e.toString(), error: e);
    }
  }
}
