import 'package:pokeglobal/core/use_case/use_case_response.dart';

/// Contrato base para use cases (Clean Architecture).
/// [T] = tipo de dato que devuelve el caso de uso.
/// [P] = tipo de parámetros de entrada (opcional; usar [void] o [Nothing] si no hay).
abstract interface class UseCase<T, P> {
  Future<UseCaseResponse<T>> call(P params);
}
