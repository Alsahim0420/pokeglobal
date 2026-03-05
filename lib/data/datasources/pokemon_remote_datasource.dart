import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';

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
    final response = await _dio.get<Map<String, dynamic>>('/pokemon/$id');
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
    return PokemonDetailDto.fromJson(data);
  }
}

final pokemonRemoteDatasourceProvider = Provider<PokemonRemoteDatasource>((ref) {
  final dio = ref.watch(pokeApiDioProvider);
  return PokemonRemoteDatasource(dio);
});
