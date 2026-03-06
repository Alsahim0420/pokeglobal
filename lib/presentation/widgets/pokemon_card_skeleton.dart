import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/utils/responsive.dart';

/// Skeleton de una card de Pokémon: misma estructura (izq. número/nombre/chips, der. sprite)
/// con efecto shimmer. Usar en estado de carga de la lista.
class PokemonCardSkeleton extends StatefulWidget {
  const PokemonCardSkeleton({super.key});

  @override
  State<PokemonCardSkeleton> createState() => _PokemonCardSkeletonState();
}

class _PokemonCardSkeletonState extends State<PokemonCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = Responsive.cardHeight(width);
    final scale = Responsive.cardScale(width);
    final borderRadius =
        PokemonTypeStyle.cardBorderRadius * scale;
    final rightRadius = PokemonTypeStyle.rightSectionBorderRadius * scale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonBase = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : AppColors.skeletonLight;
    final shimmerColor = isDark
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.white.withValues(alpha: 0.35);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: skeletonBase,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              children: [
                Row(
                  children: [
                    _LeftSkeleton(scale: scale, isDark: isDark),
                    _RightSkeleton(
                      scale: scale,
                      rightRadius: rightRadius,
                      isDark: isDark,
                    ),
                  ],
                ),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final shimmerWidth = constraints.maxWidth * 0.4;
                      final dx = constraints.maxWidth * 0.25 * _animation.value;
                      return Transform.translate(
                        offset: Offset(dx, 0),
                        child: Container(
                          width: shimmerWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                shimmerColor,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LeftSkeleton extends StatelessWidget {
  const _LeftSkeleton({required this.scale, required this.isDark});

  final double scale;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 10 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(width: 48 * scale, height: 10 * scale, isDark: isDark),
            SizedBox(height: 6 * scale),
            _ShimmerBox(width: 100 * scale, height: 16 * scale, isDark: isDark),
            const Spacer(),
            Wrap(
              spacing: 6 * scale,
              runSpacing: 4 * scale,
              children: [
                _ShimmerBox(width: 52 * scale, height: 20 * scale, borderRadius: 20, isDark: isDark),
                _ShimmerBox(width: 52 * scale, height: 20 * scale, borderRadius: 20, isDark: isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RightSkeleton extends StatelessWidget {
  const _RightSkeleton({
    required this.scale,
    required this.rightRadius,
    required this.isDark,
  });

  final double scale;
  final double rightRadius;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final padding = 6 * scale;
    final circleSize = 72 * scale;
    final colorScheme = Theme.of(context).colorScheme;
    final midColor = isDark ? colorScheme.outline.withValues(alpha: 0.4) : AppColors.skeletonMid;
    final circleColor = isDark ? colorScheme.outline.withValues(alpha: 0.6) : AppColors.skeletonCircle;

    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(rightRadius),
          child: Container(
            color: midColor,
            child: Center(
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 6,
    required this.isDark,
  });

  final double width;
  final double height;
  final double borderRadius;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)
        : AppColors.skeletonDark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
