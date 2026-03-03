import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/core/network/dio_provider.dart';

/// Datasource remoto de ejemplo. Usa Dio inyectado.
class ExampleRemoteDatasource {
  ExampleRemoteDatasource(this._dio);

  // ignore: unused_field - sustituir por _dio.get('/path') al conectar API real
  final Dio _dio;

  /// Ejemplo: GET que devuelve un mapa. En producción: _dio.get('/examples/$id').
  Future<Map<String, dynamic>> fetchExample(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return <String, dynamic>{
      'id': id,
      'title': 'Example $id',
    };
  }
}

final exampleRemoteDatasourceProvider = Provider<ExampleRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return ExampleRemoteDatasource(dio);
});
