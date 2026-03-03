/// Entidad de dominio de ejemplo (capa domain).
/// Representa el modelo de negocio sin detalles de persistencia.
class ExampleEntity {
  const ExampleEntity({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
