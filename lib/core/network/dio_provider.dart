import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor de [Dio] para inyección en datasources y repositorios.
/// Configura baseUrl, timeouts e interceptors según necesidad.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  // Añadir baseUrl cuando tengas API: dio.options.baseUrl = 'https://api.example.com';
  // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
});
