import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/l10n/type_label_helper.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/providers/pokemon_detail_provider.dart';
import 'package:pokeglobal/presentation/widgets/detail_stat_card.dart';
import 'package:pokeglobal/presentation/widgets/gender_ratio_bar.dart';
import 'package:pokeglobal/presentation/widgets/pokemon_detail_skeleton.dart';
import 'package:pokeglobal/presentation/widgets/pokemon_header_painter.dart';
import 'package:pokeglobal/presentation/widgets/type_chip.dart';

class PokemonDetailScreen extends ConsumerStatefulWidget {
  const PokemonDetailScreen({
    super.key,
    required this.pokemonName,
    this.initialHeaderColor,
    this.initialSpriteUrl,
    this.heroTagPrefix,
  });

  /// Nombre o slug del Pokémon (ej. "bulbasaur") para la API.
  final String pokemonName;

  /// Color del header mientras carga (ej. el tipo de la card en el home). Si null, usa verde por defecto.
  final Color? initialHeaderColor;

  /// URL del sprite para mostrar en el skeleton mientras carga (desde la lista).
  final String? initialSpriteUrl;

  /// Prefijo para Hero tags (debe coincidir con la lista de origen, ej. 'fav-' desde Favoritos).
  final String? heroTagPrefix;

  @override
  ConsumerState<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends ConsumerState<PokemonDetailScreen> {
  PokemonDetail? _detail;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
      _detail = null;
    });

    final useCase = ref.read(getPokemonDetailUseCaseProvider);
    final params = GetPokemonDetailParams(widget.pokemonName);
    final response = await useCase(params);

    if (!mounted) return;
    response.when(
      success: (detail) {
        setState(() {
          _detail = detail;
          _loading = false;
          _errorMessage = null;
        });
      },
      failure: (message, _) {
        setState(() {
          _errorMessage = message;
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PokemonDetailSkeleton(
        onBack: () => Navigator.of(context).pop(),
        pokemonName: widget.pokemonName,
        headerColor: widget.initialHeaderColor,
        spriteUrl: widget.initialSpriteUrl,
        heroTagPrefix: widget.heroTagPrefix,
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.green8B,
        appBar: _buildAppBar(context, showActions: false),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.white),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _loadDetail,
                  child: Text(
                    AppLocalizations.of(context)!.detailRetry,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final d = _detail!;
    final headerColor = d.typeLabels.isNotEmpty
        ? PokemonTypeStyle.chipStyle(d.typeLabels.first).color
        : AppColors.green8B;

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
                const SizedBox(height: 16),
                _buildTitleSection(d),
                const SizedBox(height: 16),
                if (d.description.isNotEmpty) _buildDescription(d.description),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: colorScheme.outline.withValues(alpha: 0.6),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 22),
                _buildStatsGrid(d),
                const SizedBox(height: 20),
                if (d.genderMalePercent > 0 || d.genderFemalePercent > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GenderRatioBar(
                      malePercent: d.genderMalePercent,
                      femalePercent: d.genderFemalePercent,
                    ),
                  ),
                if (d.genderMalePercent > 0 || d.genderFemalePercent > 0)
                  const SizedBox(height: 24),
                _buildWeaknesses(d.weaknessLabels),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(d, headerColor),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required bool showActions,
  }) {
    return AppBar(
      backgroundColor: AppColors.green8B,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: showActions && _detail != null
          ? [
              Consumer(
                builder: (context, ref, _) {
                  final isFav = ref
                      .watch(favoriteIdsProvider)
                      .contains(_detail!.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppColors.redE5 : AppColors.white,
                    ),
                    onPressed: () => ref
                        .read(favoriteIdsProvider.notifier)
                        .toggle(_detail!.id, nameSlug: _detail!.nameSlug),
                  );
                },
              ),
            ]
          : null,
    );
  }

  Widget _buildHeader(PokemonDetail d, Color headerColor) {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DetailHeaderPainter(headerColor)),
          ),
          Positioned.fill(
            child: Center(
              child: d.typeLabels.isNotEmpty
                  ? Hero(
                      tag:
                          '${widget.heroTagPrefix ?? ""}pokemon-type-icon-${d.nameSlug}',
                      child: Material(
                        color: Colors.transparent,
                        child: ShaderMask(
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (bounds) => AppColors
                              .typeIconBackGradient
                              .createShader(bounds),
                          child: SvgPicture.asset(
                            PokemonTypeStyle.chipStyle(
                              d.typeLabels.first,
                            ).iconPath,
                            width: 140,
                            height: 140,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: Hero(
              tag:
                  '${widget.heroTagPrefix ?? ""}pokemon-favorite-${d.nameSlug}',
              child: Material(
                color: Colors.transparent,
                child: Consumer(
                  builder: (context, ref, _) {
                    final isFav = ref.watch(favoriteIdsProvider).contains(d.id);
                    return IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          key: ValueKey<bool>(isFav),
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppColors.redE5 : AppColors.white,
                        ),
                      ),
                      onPressed: () => ref
                          .read(favoriteIdsProvider.notifier)
                          .toggle(d.id, nameSlug: d.nameSlug),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            child: Center(
              child: Hero(
                tag: '${widget.heroTagPrefix ?? ""}pokemon-image-${d.nameSlug}',
                child: _buildHeaderSprite(d),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSprite(PokemonDetail d) {
    const double size = 145;
    return Material(
      color: Colors.transparent,
      child: Image.network(
        d.spriteUrl,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : SizedBox(
                height: size,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
              ),
        errorBuilder: (_, __, ___) =>
            Icon(Icons.catching_pokemon, size: 80, color: AppColors.white),
      ),
    );
  }

  Widget _buildTitleSection(PokemonDetail d) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            d.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            d.number,
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: d.typeLabels.map((label) {
              final style = PokemonTypeStyle.chipStyle(label);
              return TypeChip(
                label: displayLabelInLocale(context, label),
                color: style.color,
                iconPath: style.iconPath,
                scale: 1.0,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildStatsGrid(PokemonDetail d) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                DetailStatCard(
                  iconPath: 'assets/svgs/la_weight-hanging.svg',
                  label: AppLocalizations.of(context)!.detailWeight,
                  value: '${d.weightKg.toStringAsFixed(1)} kg',
                ),
                const SizedBox(height: 20),
                DetailStatCard(
                  iconPath: 'assets/svgs/bx_category.svg',
                  label: AppLocalizations.of(context)!.detailCategory,
                  value: d.category,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                DetailStatCard(
                  iconPath: 'assets/svgs/ant-design_column-height-outlined.svg',
                  label: AppLocalizations.of(context)!.detailHeight,
                  value: '${d.heightM.toStringAsFixed(1)} m',
                ),
                const SizedBox(height: 20),
                DetailStatCard(
                  iconPath: 'assets/svgs/iconoir_pokeball.svg',
                  label: AppLocalizations.of(context)!.detailAbility,
                  value: d.ability.isNotEmpty ? d.ability : '—',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknesses(List<String> labels) {
    if (labels.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.detailWeaknesses,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: labels.map((label) {
              final style = PokemonTypeStyle.chipStyle(label);
              return TypeChip(
                label: displayLabelInLocale(context, label),
                color: style.color,
                iconPath: style.iconPath,
                scale: 1.0,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
