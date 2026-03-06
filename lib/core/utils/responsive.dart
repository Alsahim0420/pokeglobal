/// Dimensiones responsivas a partir del ancho de pantalla.
/// Una sola fuente para márgenes, alturas de card y escalado.
abstract final class Responsive {
  Responsive._();

  /// Altura base de la card (diseño de referencia).
  static const double baseCardHeight = 108;

  /// Card height en función del ancho: ~28–30% del ancho, entre 96 y 140.
  static double cardHeight(double screenWidth) {
    final height = screenWidth * 0.29;
    return height.clamp(90.0, 100.0);
  }

  /// Factor de escala respecto al diseño base (108px de altura).
  static double cardScale(double screenWidth) {
    return cardHeight(screenWidth) / baseCardHeight;
  }

  /// Padding horizontal de la lista en función del ancho.
  static double listHorizontalPadding(double screenWidth) {
    final padding = screenWidth * 0.05;
    return padding.clamp(16.0, 28.0);
  }

  /// Padding horizontal del search bar.
  static double searchBarHorizontalPadding(double screenWidth) {
    return listHorizontalPadding(screenWidth);
  }

  /// Separación entre cards.
  static double listItemSpacing(double screenWidth) {
    final scale = cardScale(screenWidth);
    return (10 * scale).clamp(8.0, 14.0);
  }
}
