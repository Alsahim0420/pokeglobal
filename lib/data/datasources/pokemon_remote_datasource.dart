import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/core/env/app_env.dart';
import 'package:pokeglobal/core/security/secure_config.dart';
import 'package:pokeglobal/data/models/pokemon_detail_dto.dart';
import 'package:pokeglobal/data/models/pokemon_list_response_dto.dart';
import 'package:pokeglobal/data/models/pokemon_species_dto.dart';

/// Dio configurado solo para PokeAPI (evita mutar el Dio global).
/// BaseUrl y validación HTTPS desde [AppEnv]. Logs solo en debug.
final pokeApiDioProvider = Provider<Dio>((ref) {
  final baseUrl = ensureHttps(AppEnv.pokeApiBaseUrl);
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  // Logs solo en debug para no exponer datos en release
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      error: true,
    ));
  }
  return dio;
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

  /// GET /type/{name} — lista de Pokémon de ese tipo (todos).
  Future<List<({int id, String name})>> getPokemonByType(String apiTypeName) async {
    final slug = apiTypeName.toLowerCase().trim();
    final response = await _dio.get<Map<String, dynamic>>('/type/$slug');
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
    final list = data['pokemon'] as List<dynamic>? ?? [];
    return list.map((e) {
      final pokemon = (e as Map<String, dynamic>)['pokemon'] as Map<String, dynamic>?;
      final name = pokemon?['name'] as String? ?? '';
      final url = pokemon?['url'] as String? ?? '';
      final segments = url.replaceFirst(RegExp(r'/$'), '').split('/');
      final id = int.tryParse(segments.isNotEmpty ? segments.last : '') ?? 0;
      return (id: id, name: name);
    }).where((e) => e.id > 0).toList();
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
