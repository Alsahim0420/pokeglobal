import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pokeglobal/data/repositories/pokemon_repository_impl.dart';
import 'package:pokeglobal/domain/usecases/enrich_pokemon_list_use_case.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_by_types_use_case.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_use_case.dart';

part 'pokemon_list_provider.g.dart';

@riverpod
GetPokemonListUseCase getPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonListUseCase(repository);
}

@riverpod
EnrichPokemonListUseCase enrichPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return EnrichPokemonListUseCase(repository);
}

@riverpod
GetPokemonListByTypesUseCase getPokemonListByTypesUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonListByTypesUseCase(repository);
}
