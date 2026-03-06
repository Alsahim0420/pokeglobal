import 'package:pokeglobal/domain/entities/example_entity.dart';

/// Contrato del repositorio de ejemplo (capa domain).
/// La implementación vive en data.
abstract interface class ExampleRepository {
  Future<ExampleEntity?> getExample(String id);
}
