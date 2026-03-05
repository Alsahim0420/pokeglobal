import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';

/// Base URL de PokeAPI v2.
const String pokeApiBaseUrl = 'https://pokeapi.co/api/v2';

/// Dio configurado solo para PokeAPI (evita mutar el Dio global).
final pokeApiDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: pokeApiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
});

/// Datasource remoto de Pokémon (PokeAPI). Solo conoce HTTP y DTOs.
class PokemonRemoteDatasource {
  PokemonRemoteDatasource(this._dio);

  final Dio _dio;

  /// GET /pokemon?limit=&offset=
  Future<PokemonListResponseDto> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/pokemon',
      queryParameters: <String, dynamic>{
        'limit': limit,
        'offset': offset,
      },
    );

    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    return PokemonListResponseDto.fromJson(data);
  }

  /// GET /pokemon/{id} — detalle (tipos, etc.).
  Future<PokemonDetailDto> getPokemonDetail(int id) async {
    final data = await _getPokemonJson('/pokemon/$id');
    return PokemonDetailDto.fromJson(data);
  }

  /// GET /pokemon/{name} — detalle por nombre (slug).
  Future<PokemonDetailDto> getPokemonDetailByName(String name) async {
    final slug = name.toLowerCase().trim();
    final data = await _getPokemonJson('/pokemon/$slug');
    return PokemonDetailDto.fromJson(data);
  }

  Future<Map<String, dynamic>> _getPokemonJson(String path) async {
    final response = await _dio.get<Map<String, dynamic>>(path);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
    return data;
  }

  /// GET /pokemon-species/{id} — descripción y género.
  Future<PokemonSpeciesDto> getPokemonSpecies(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/pokemon-species/$id');
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
    return PokemonSpeciesDto.fromJson(data);
  }
}

final pokemonRemoteDatasourceProvider = Provider<PokemonRemoteDatasource>((ref) {
  final dio = ref.watch(pokeApiDioProvider);
  return PokemonRemoteDatasource(dio);
});
