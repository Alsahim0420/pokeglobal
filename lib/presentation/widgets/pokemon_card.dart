import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/utils/responsive.dart';
import 'package:pokeglobal/presentation/widgets/type_chip.dart';

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
    this.heroTagPrefix,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.gradient,
    required this.rightSectionColor,
    this.onTap,
  });

  final String number;
  final String name;
  final List<TypeChipData> typeChips;
  final String spriteUrl;

  /// Nombre en minúsculas (slug) para Hero tags y referencias.
  final String? nameSlug;

  /// Prefijo opcional para los Hero tags (evita duplicados cuando la misma card aparece en varias listas, ej. 'fav-').
  final String? heroTagPrefix;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final LinearGradient gradient;
  final Color rightSectionColor;

  /// Tap simple (ej. navegar al detalle). Doble tap sigue siendo [onFavoriteTap].
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = Responsive.cardHeight(width);
    final scale = Responsive.cardScale(width);

    final borderRadius =
        BorderRadius.circular(PokemonTypeStyle.cardBorderRadius * scale);
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onFavoriteTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.white,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
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
              heroTagPrefix: heroTagPrefix,
              isFavorite: isFavorite,
              onFavoriteTap: onFavoriteTap,
              backgroundColor: rightSectionColor,
              scale: scale,
              type: typeChips.isNotEmpty
                  ? typeChips.first.iconPath
                  : PokemonTypeStyle.chipStyle('Normal').iconPath,
            ),
          ],
            ),
          ),
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
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2 * scale),
            Text(
              name,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: (25 * scale).roundToDouble(),
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
    this.heroTagPrefix,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.backgroundColor,
    required this.scale,
    required this.type,
  });

  final String spriteUrl;
  final String? nameSlug;
  final String? heroTagPrefix;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final Color backgroundColor;
  final double scale;
  final String type;

  @override
  Widget build(BuildContext context) {
    final padding = 6 * scale;
    final imageSize = 58 * scale;
    final fallbackIconSize = 28 * scale;

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
                child: Hero(
                  tag:
                      '${heroTagPrefix ?? ""}pokemon-type-icon-${nameSlug ?? ""}',
                  child: Material(
                    color: Colors.transparent,
                    child: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (bounds) =>
                          AppColors.typeIconBackGradient.createShader(bounds),
                      child: SvgPicture.asset(
                        type,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: '${heroTagPrefix ?? ""}pokemon-image-${nameSlug ?? ""}',
                  child: Material(
                    color: Colors.transparent,
                    child: _buildSprite(imageSize, fallbackIconSize),
                  ),
                ),
              ),
              Positioned(
                top: padding,
                right: padding,
                child: _FavoriteButton(
                  nameSlug: nameSlug,
                  heroTagPrefix: heroTagPrefix,
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
    return Image.network(
      spriteUrl,
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
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.nameSlug,
    this.heroTagPrefix,
    required this.isFavorite,
    required this.onTap,
    required this.scale,
  });

  final String? nameSlug;
  final String? heroTagPrefix;
  final bool isFavorite;
  final VoidCallback onTap;
  final double scale;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  static const Duration _heartbeatDuration = Duration(milliseconds: 380);
  late AnimationController _heartbeatController;
  late Animation<double> _heartbeatScale;

  @override
  void initState() {
    super.initState();
    _heartbeatController = AnimationController(
      vsync: this,
      duration: _heartbeatDuration,
    );
    _heartbeatScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 15),
          TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 10),
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 15),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 15),
        ]).animate(
          CurvedAnimation(parent: _heartbeatController, curve: Curves.easeOut),
        );
  }

  @override
  void didUpdateWidget(_FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isFavorite && widget.isFavorite) {
      _heartbeatController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 30 * widget.scale;
    final iconSize = 16 * widget.scale;

    return Hero(
      tag:
          '${widget.heroTagPrefix ?? ""}pokemon-favorite-${widget.nameSlug ?? ""}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey42.withOpacity(0.4),
              border: Border.all(
                color: AppColors.white,
                width: (1.5 * widget.scale).clamp(1.0, 2.0),
              ),
            ),
            child: AnimatedBuilder(
              animation: _heartbeatScale,
              builder: (context, child) {
                final s = widget.isFavorite && _heartbeatController.isAnimating
                    ? _heartbeatScale.value
                    : 1.0;
                return Transform.scale(
                  scale: s,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  key: ValueKey<bool>(widget.isFavorite),
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite ? AppColors.redE5 : AppColors.white,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
