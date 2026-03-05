import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_assets.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/utils/responsive.dart';
import 'package:pokeglobal/widgets/type_chip.dart';

/// DTO de presentación para los chips de tipo (evita acoplar dominio al widget).
class TypeChipData {
  const TypeChipData({
    required this.label,
    required this.color,
    required this.iconPath,
  });

  final String label;
  final Color color;
  final String iconPath;
}

/// Tarjeta Pokémon presentacional. Recibe datos ya mapeados; no conoce dominio.
class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.number,
    required this.name,
    required this.typeChips,
    required this.spriteUrl,
    this.nameSlug,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.gradient,
    required this.rightSectionColor,
  });

  final String number;
  final String name;
  final List<TypeChipData> typeChips;
  final String spriteUrl;

  /// Nombre en minúsculas (slug) para SVG local; si hay asset, se usa en lugar de [spriteUrl].
  final String? nameSlug;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final LinearGradient gradient;
  final Color rightSectionColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = Responsive.cardHeight(width);
    final scale = Responsive.cardScale(width);

    return GestureDetector(
      onDoubleTap: onFavoriteTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            PokemonTypeStyle.cardBorderRadius * scale,
          ),
          gradient: gradient,
        ),
        child: Row(
          children: [
            _LeftContent(
              number: number,
              name: name,
              typeChips: typeChips,
              scale: scale,
            ),
            _RightSection(
              spriteUrl: spriteUrl,
              nameSlug: nameSlug,
              isFavorite: isFavorite,
              onFavoriteTap: onFavoriteTap,
              backgroundColor: rightSectionColor,
              scale: scale,
              type: typeChips.first.iconPath,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftContent extends StatelessWidget {
  const _LeftContent({
    required this.number,
    required this.name,
    required this.typeChips,
    required this.scale,
  });

  final String number;
  final String name;
  final List<TypeChipData> typeChips;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12 * scale,
          vertical: 10 * scale,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: (11 * scale).roundToDouble(),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2 * scale),
            Text(
              name,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: (18 * scale).roundToDouble(),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 6 * scale,
              runSpacing: 4 * scale,
              children: typeChips
                  .map(
                    (t) => TypeChip(
                      label: t.label,
                      color: t.color,
                      iconPath: t.iconPath,
                      scale: scale,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RightSection extends StatelessWidget {
  const _RightSection({
    required this.spriteUrl,
    this.nameSlug,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.backgroundColor,
    required this.scale,
    required this.type,
  });

  final String spriteUrl;
  final String? nameSlug;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final Color backgroundColor;
  final double scale;
  final String type;

  @override
  Widget build(BuildContext context) {
    final padding = 6 * scale;
    final imageSize = 100 * scale;
    final fallbackIconSize = 44 * scale;

    return Expanded(
      flex: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          PokemonTypeStyle.rightSectionBorderRadius * scale,
        ),
        child: Container(
          decoration: BoxDecoration(color: backgroundColor),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  type,
                  color: AppColors.white.withOpacity(0.2),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildSprite(imageSize, fallbackIconSize),
              ),
              Positioned(
                top: padding,
                right: padding,
                child: _FavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteTap,
                  scale: scale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSprite(double imageSize, double fallbackIconSize) {
    final slug = nameSlug?.toLowerCase().trim();
    final path = slug != null && slug.isNotEmpty
        ? PokemonAssets.path(slug)
        : null;

    if (path != null) {
      return Image.asset(
        path,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.catching_pokemon,
          size: fallbackIconSize,
          color: AppColors.white,
        ),
      );
    }
    return Icon(
      Icons.catching_pokemon,
      size: fallbackIconSize,
      color: AppColors.white,
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    required this.scale,
  });

  final bool isFavorite;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final size = 30 * scale;
    final iconSize = 16 * scale;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey42.withOpacity(0.4),
            border: Border.all(
              color: AppColors.white,
              width: (1.5 * scale).clamp(1.0, 2.0),
            ),
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.redE5 : AppColors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
