import 'package:freezed_annotation/freezed_annotation.dart';

part 'use_case_response.freezed.dart';

/// Modelo de respuesta estándar para todos los use cases.
/// Usar [UseCaseResponse.success] o [UseCaseResponse.failure] y hacer
/// [when]/[map]/[maybeWhen] en la UI o en el use case que orquesta.
@freezed
sealed class UseCaseResponse<T> with _$UseCaseResponse<T> {
  const factory UseCaseResponse.success(T data) = _Success<T>;
  const factory UseCaseResponse.failure(String message, {Object? error}) = _Failure<T>;
}
