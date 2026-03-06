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

  /// Colores fuertes de chips (paleta definida por diseño).
  static Color _chipColor(String label) {
    switch (label) {
      case 'Agua':
        return const Color(0xFF2196F3);
      case 'Dragón':
        return const Color(0xFF00ACC1);
      case 'Eléctrico':
        return const Color(0xFFFDD835);
      case 'Hada':
        return const Color(0xFFE91E63);
      case 'Fantasma':
        return const Color(0xFF8E24AA);
      case 'Fuego':
        return const Color(0xFFFF9800);
      case 'Hielo':
        return const Color(0xFF3D8BFF);
      case 'Planta':
        return const Color(0xFF8BC34A);
      case 'Bicho':
        return const Color(0xFF43A047);
      case 'Lucha':
        return const Color(0xFFE53935);
      case 'Normal':
        return const Color(0xFF546E7A);
      case 'Siniestro':
        return const Color(0xFF546E7A);
      case 'Acero':
        return const Color(0xFF546E7A);
      case 'Roca':
        return const Color(0xFF795548);
      case 'Psíquico':
        return const Color(0xFF673AB7);
      case 'Tierra':
        return const Color(0xFFFFB300);
      case 'Veneno':
        return const Color(0xFF9C27B0);
      case 'Volador':
        return const Color(0xFF00BCD4);
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

  /// Misma paleta de colores del type [50% Transparencia]

  static (List<Color> gradient, Color rightSection) _cardColors(String first) {
    switch (first) {
      case 'Agua':
        return _same(const Color(0xFF2196F3).withOpacity(0.5));
      case 'Dragón':
        return _same(const Color(0xFF00ACC1).withOpacity(0.5));
      case 'Eléctrico':
        return _same(const Color(0xFFFDD835).withOpacity(0.5));
      case 'Hada':
        return _same(const Color(0xFFE91E63).withOpacity(0.5));
      case 'Fantasma':
        return _same(const Color(0xFF8E24AA).withOpacity(0.5));
      case 'Fuego':
        return _same(const Color(0xFFFF9800).withOpacity(0.5));
      case 'Hielo':
        return _same(const Color(0xFF3D8BFF).withOpacity(0.5));
      case 'Planta':
        return _same(const Color(0xFF8BC34A).withOpacity(0.5));
      case 'Bicho':
        return _same(const Color(0xFF43A047).withOpacity(0.5));
      case 'Lucha':
        return _same(const Color(0xFFE53935).withOpacity(0.5));
      case 'Normal':
        return _same(const Color(0xFF546E7A).withOpacity(0.5));
      case 'Siniestro':
        return _same(const Color(0xFF546E7A).withOpacity(0.5));
      case 'Acero':
        return _same(const Color(0xFF546E7A).withOpacity(0.5));
      case 'Roca':
        return _same(const Color(0xFF795548).withOpacity(0.5));
      case 'Psíquico':
        return _same(const Color(0xFF673AB7).withOpacity(0.5));
      case 'Tierra':
        return _same(const Color(0xFFFFB300).withOpacity(0.5));
      case 'Veneno':
        return _same(const Color(0xFF9C27B0).withOpacity(0.5));
      case 'Volador':
        return _same(const Color(0xFF00BCD4).withOpacity(0.5));
      default:
        return ([AppColors.greyE0, AppColors.greyD6], AppColors.grey9E);
    }
  }

  static (List<Color>, Color) _same(Color color) => ([color, color], color);

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
