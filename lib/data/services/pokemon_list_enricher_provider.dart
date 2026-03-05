import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokeglobal/data/services/pokemon_list_enricher.dart';

final pokemonListEnricherProvider = Provider<PokemonListEnricher>((ref) {
  final datasource = ref.watch(pokemonRemoteDatasourceProvider);
  return PokemonListEnricher(datasource);
});
