import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/services/svg_asset_service.dart';

/// Única fuente de verdad para estilos de tipos Pokémon y colores de card.
/// Core no depende de dominio; recibe [typeLabels] como [List<String].
/// SOLID: responsabilidad única; sin duplicar en pantallas ni widgets.
abstract final class PokemonTypeStyle {
  PokemonTypeStyle._();

  static const double cardBorderRadius = 20;
  static const double rightSectionBorderRadius = 18;

  static Color _chipColor(String label) {
    switch (label) {
      case 'Normal':
        return const Color(0xFFA8A878);
      case 'Fuego':
        return const Color(0xFFF08030);
      case 'Agua':
        return const Color(0xFF6890F0);
      case 'Eléctrico':
        return const Color(0xFFF8D030);
      case 'Planta':
        return const Color(0xFF78C850);
      case 'Hielo':
        return const Color(0xFF98D8D8);
      case 'Lucha':
        return const Color(0xFFC03028);
      case 'Veneno':
        return const Color(0xFFA040A0);
      case 'Tierra':
        return const Color(0xFFE0C068);
      case 'Volador':
        return const Color(0xFFA890F0);
      case 'Psíquico':
        return const Color(0xFFF85888);
      case 'Bicho':
        return const Color(0xFFA8B820);
      case 'Roca':
        return const Color(0xFFB8A038);
      case 'Fantasma':
        return const Color(0xFF705898);
      case 'Dragón':
        return const Color(0xFF7038F8);
      case 'Siniestro':
        return const Color(0xFF705848);
      case 'Acero':
        return const Color(0xFFB8B8D0);
      case 'Hada':
        return const Color(0xFFEE99AC);
      default:
        return AppColors.grey9E;
    }
  }

  /// Estilo del chip (color + ruta SVG del icono) por etiqueta de tipo.
  static ({Color color, String iconPath}) chipStyle(String label) {
    return (
      color: _chipColor(label),
      iconPath: SvgAssetService.typePathFromLabel(label),
    );
  }

  static (List<Color> gradient, Color rightSection) _cardColors(String first) {
    switch (first) {
      case 'Normal':
        return ([const Color(0xFFA8A878), const Color(0xFF909090)], const Color(0xFF8A8A6A));
      case 'Fuego':
        return ([const Color(0xFFFFB74D), const Color(0xFFFFA726)], const Color(0xFFFB8C00));
      case 'Agua':
        return ([const Color(0xFF64B5F6), const Color(0xFF42A5F5)], const Color(0xFF1E88E5));
      case 'Eléctrico':
        return ([const Color(0xFFFFF176), const Color(0xFFFFEE58)], const Color(0xFFFDD835));
      case 'Planta':
      case 'Veneno':
        return ([const Color(0xFFAED581), const Color(0xFF8BC34A)], const Color(0xFF7CB342));
      case 'Hielo':
        return ([const Color(0xFFB3E5FC), const Color(0xFF81D4FA)], const Color(0xFF4FC3F7));
      case 'Lucha':
        return ([const Color(0xFFEF9A9A), const Color(0xFFE57373)], const Color(0xFFE53935));
      case 'Tierra':
        return ([const Color(0xFFD7CCC8), const Color(0xFFBCAAA4)], const Color(0xFF8D6E63));
      case 'Volador':
        return ([const Color(0xFFB39DDB), const Color(0xFF9575CD)], const Color(0xFF7E57C2));
      case 'Psíquico':
        return ([const Color(0xFFF48FB1), const Color(0xFFF06292)], const Color(0xFFEC407A));
      case 'Bicho':
        return ([const Color(0xFFCDDC39), const Color(0xFFC0CA33)], const Color(0xFFAFB42B));
      case 'Roca':
        return ([const Color(0xFFA1887F), const Color(0xFF8D6E63)], const Color(0xFF6D4C41));
      case 'Fantasma':
        return ([const Color(0xFF9575CD), const Color(0xFF7E57C2)], const Color(0xFF5E35B1));
      case 'Dragón':
        return ([const Color(0xFF7E57C2), const Color(0xFF673AB7)], const Color(0xFF512DA8));
      case 'Siniestro':
        return ([const Color(0xFF5D4037), const Color(0xFF4E342E)], const Color(0xFF3E2723));
      case 'Acero':
        return ([const Color(0xFFB0BEC5), const Color(0xFF90A4AE)], const Color(0xFF78909C));
      case 'Hada':
        return ([const Color(0xFFF8BBD9), const Color(0xFFF48FB1)], const Color(0xFFEC407A));
      default:
        return ([AppColors.greyE0, AppColors.greyD6], AppColors.grey9E);
    }
  }

  /// Gradiente de la card según el primer tipo.
  static LinearGradient cardGradient(List<String> typeLabels) {
    final first = typeLabels.isNotEmpty ? typeLabels.first : '';
    final (gradient, _) = _cardColors(first);
    return LinearGradient(
      colors: gradient,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  /// Color del bloque derecho de la card (fondo del sprite).
  static Color rightSectionColor(List<String> typeLabels) {
    final first = typeLabels.isNotEmpty ? typeLabels.first : '';
    final (_, right) = _cardColors(first);
    return right;
  }
}
