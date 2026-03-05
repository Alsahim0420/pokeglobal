import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

/// Chip de tipo reutilizable (círculo blanco con icono SVG + etiqueta).
/// Usado en [PokemonCard] y cualquier otra vista que muestre tipos.
/// [scale] permite adaptar tamaño en layouts responsivos (default 1.0).
class TypeChip extends StatelessWidget {
  const TypeChip({
    super.key,
    required this.label,
    required this.color,
    required this.iconPath,
    this.scale = 1.0,
  });

  final String label;
  final Color color;
  final String iconPath;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final iconSize = 20 * scale;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(0.1),
            child: SvgPicture.asset(
              iconPath,
              width: iconSize * 0.7,
              height: iconSize * 0.7,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 5 * scale),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 11 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
