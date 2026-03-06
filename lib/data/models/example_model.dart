import 'package:pokeglobal/domain/entities/example_entity.dart';

/// DTO / modelo de datos (capa data).
/// Convierte desde JSON y a [ExampleEntity].
class ExampleModel {
  const ExampleModel({required this.id, required this.title});

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  final String id;
  final String title;

  ExampleEntity toEntity() => ExampleEntity(id: id, title: title);
}
