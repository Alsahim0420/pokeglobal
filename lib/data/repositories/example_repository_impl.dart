import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/data/datasources/example_remote_datasource.dart';
import 'package:pokeglobal/data/models/example_model.dart';
import 'package:pokeglobal/domain/entities/example_entity.dart';
import 'package:pokeglobal/domain/repositories/example_repository.dart';

/// Implementación del repositorio de ejemplo (capa data).
class ExampleRepositoryImpl implements ExampleRepository {
  ExampleRepositoryImpl(this._remote);

  final ExampleRemoteDatasource _remote;

  @override
  Future<ExampleEntity?> getExample(String id) async {
    final json = await _remote.fetchExample(id);
    return ExampleModel.fromJson(json).toEntity();
  }
}

final exampleRepositoryProvider = Provider<ExampleRepository>((ref) {
  final remote = ref.watch(exampleRemoteDatasourceProvider);
  return ExampleRepositoryImpl(remote);
});
