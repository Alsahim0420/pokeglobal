import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokeglobal/domain/usecases/enrich_pokemon_list_use_case.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_by_types_use_case.dart';
import 'package:pokeglobal/presentation/providers/pokemon_list_provider.dart';
import '../../helpers/fake_pokemon_repository.dart';

void main() {
  test('getPokemonListUseCaseProvider devuelve use case', () {
    final container = ProviderContainer(
      overrides: [
        pokemonRepositoryProvider.overrideWithValue(FakePokemonRepository()),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(getPokemonListUseCaseProvider), isA<GetPokemonListUseCase>());
  });

  test('enrichPokemonListUseCaseProvider devuelve use case', () {
    final container = ProviderContainer(
      overrides: [
        pokemonRepositoryProvider.overrideWithValue(FakePokemonRepository()),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(enrichPokemonListUseCaseProvider), isA<EnrichPokemonListUseCase>());
  });

  test('getPokemonListByTypesUseCaseProvider devuelve use case', () {
    final container = ProviderContainer(
      overrides: [
        pokemonRepositoryProvider.overrideWithValue(FakePokemonRepository()),
      ],
    );
    addTearDown(container.dispose);
    expect(container.read(getPokemonListByTypesUseCaseProvider), isA<GetPokemonListByTypesUseCase>());
  });
}
