import 'package:pokeglobal/core/use_case/use_case.dart';
import 'package:pokeglobal/core/use_case/use_case_response.dart';
import 'package:pokeglobal/domain/entities/example_entity.dart';
import 'package:pokeglobal/domain/repositories/example_repository.dart';

/// Use case de ejemplo: obtiene un [ExampleEntity] por id.
/// Respuesta unificada con [UseCaseResponse].
class GetExampleUseCase implements UseCase<ExampleEntity?, String> {
  GetExampleUseCase(this._repository);

  final ExampleRepository _repository;

  @override
  Future<UseCaseResponse<ExampleEntity?>> call(String params) async {
    try {
      final entity = await _repository.getExample(params);
      return UseCaseResponse.success(entity);
    } catch (e) {
      return UseCaseResponse.failure(
        e.toString(),
        error: e,
      );
    }
  }
}
