import 'package:pokeglobal/core/use_case/use_case.dart';
import 'package:pokeglobal/core/use_case/use_case_response.dart';
import 'package:pokeglobal/domain/repositories/pokemon_repository.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';

/// Caso de uso: obtiene todos los Pokémon que tienen alguno de los tipos indicados.
/// Usa la API /type/{name} para cada tipo (todos los Pokémon del tipo).
class GetPokemonListByTypesUseCase
    implements UseCase<List<PokemonCardItem>, List<String>> {
  GetPokemonListByTypesUseCase(this._repository);

  final PokemonRepository _repository;

  @override
  Future<UseCaseResponse<List<PokemonCardItem>>> call(
      List<String> displayTypeLabels) async {
    try {
      final list = await _repository.getPokemonListByTypes(displayTypeLabels);
      return UseCaseResponse.success(list);
    } catch (e) {
      return UseCaseResponse.failure(
        e.toString(),
        error: e,
      );
    }
  }
}
