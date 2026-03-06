import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/widgets/pokemon_header_painter.dart';

/// Skeleton solo del contenido desde el nombre hacia abajo.
/// El header (painter + imagen local) se muestra normal; solo la zona de nombre, stats, etc. es skeleton.
class PokemonDetailSkeleton extends StatefulWidget {
  const PokemonDetailSkeleton({
    super.key,
    this.onBack,
    this.headerColor,
    this.pokemonName,
    this.spriteUrl,
    this.heroTagPrefix,
  });

  final VoidCallback? onBack;

  /// Color del header (painter). Si null, usa [AppColors.green8B].
  final Color? headerColor;

  /// Slug del Pokémon (para Hero tags).
  final String? pokemonName;

  /// URL del sprite para mostrar la imagen de red mientras carga.
  final String? spriteUrl;

  /// Prefijo para Hero tags (ej. 'fav-' desde Favoritos).
  final String? heroTagPrefix;

  @override
  State<PokemonDetailSkeleton> createState() => _PokemonDetailSkeletonState();
}

class _PokemonDetailSkeletonState extends State<PokemonDetailSkeleton>
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
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = widget.headerColor ?? AppColors.green8B;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 260),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) => _buildContentSkeleton(context),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(headerColor),
          ),
        ],
      ),
    );
  }

  /// Header real (painter + botones + loading en la imagen). No skeleton.
  Widget _buildHeader(Color headerColor) {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DetailHeaderPainter(headerColor)),
          ),
          if (widget.pokemonName != null && widget.pokemonName!.isNotEmpty)
            Positioned.fill(
              child: Center(
                child: Hero(
                  tag: '${widget.heroTagPrefix ?? ""}pokemon-type-icon-${widget.pokemonName}',
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(width: 140, height: 140),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.white),
              onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
            ),
          ),
          if (widget.pokemonName != null && widget.pokemonName!.isNotEmpty)
            Positioned(
              top: 50,
              right: 16,
              child: Hero(
                tag: '${widget.heroTagPrefix ?? ""}pokemon-favorite-${widget.pokemonName}',
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: AppColors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            )
          else
            Positioned(
              top: 50,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: AppColors.white),
                onPressed: () {},
              ),
            ),
          if (widget.pokemonName != null || widget.spriteUrl != null)
            _buildHeaderImage(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    const double size = 145;
    final url = widget.spriteUrl;
    final tag = widget.pokemonName != null && widget.pokemonName!.isNotEmpty
        ? '${widget.heroTagPrefix ?? ""}pokemon-image-${widget.pokemonName}'
        : null;
    if (url == null || url.isEmpty || tag == null) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: -40,
      left: 0,
      right: 0,
      child: Center(
        child: Hero(
          tag: tag,
          child: Material(
            color: Colors.transparent,
            child: Image.network(
              url,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSkeleton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _ShimmerBox(width: 180, height: 28, borderRadius: 8, isDark: isDark),
          const SizedBox(height: 8),
          _ShimmerBox(width: 70, height: 16, borderRadius: 6, isDark: isDark),
          const SizedBox(height: 14),
          Row(
            children: [
              _ShimmerBox(width: 64, height: 24, borderRadius: 20, isDark: isDark),
              const SizedBox(width: 8),
              _ShimmerBox(width: 64, height: 24, borderRadius: 20, isDark: isDark),
            ],
          ),
          const SizedBox(height: 16),
          _ShimmerBox(width: double.infinity, height: 14, borderRadius: 6, isDark: isDark),
          const SizedBox(height: 8),
          _ShimmerBox(width: double.infinity, height: 14, borderRadius: 6, isDark: isDark),
          const SizedBox(height: 8),
          _ShimmerBox(width: 220, height: 14, borderRadius: 6, isDark: isDark),
          const SizedBox(height: 22),
          Divider(color: colorScheme.outline),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _ShimmerBox(
                      width: double.infinity,
                      height: 56,
                      borderRadius: 16,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _ShimmerBox(
                      width: double.infinity,
                      height: 56,
                      borderRadius: 16,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _ShimmerBox(
                      width: double.infinity,
                      height: 56,
                      borderRadius: 16,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _ShimmerBox(
                      width: double.infinity,
                      height: 56,
                      borderRadius: 16,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ShimmerBox(width: 80, height: 12, borderRadius: 4, isDark: isDark),
          const SizedBox(height: 12),
          _ShimmerBox(width: double.infinity, height: 10, borderRadius: 6, isDark: isDark),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(width: 70, height: 14, borderRadius: 4, isDark: isDark),
              _ShimmerBox(width: 70, height: 14, borderRadius: 4, isDark: isDark),
            ],
          ),
          const SizedBox(height: 24),
          _ShimmerBox(width: 100, height: 16, borderRadius: 4, isDark: isDark),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              4,
              (_) => _ShimmerBox(width: 72, height: 28, borderRadius: 20, isDark: isDark),
            ),
          ),
          const SizedBox(height: 32),
        ],
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
