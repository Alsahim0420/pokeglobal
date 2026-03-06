import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/l10n/type_label_helper.dart';
import 'package:pokeglobal/core/utils/responsive.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokeglobal/data/models/pokemon_card_item.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/providers/pokemon_detail_provider.dart';
import 'package:pokeglobal/presentation/screens/pokemon_detail_screen.dart';
import 'package:pokeglobal/presentation/widgets/pokemon_card.dart';
import 'package:pokeglobal/presentation/widgets/pokemon_card_skeleton.dart';

class FavoritosScreen extends ConsumerStatefulWidget {
  const FavoritosScreen({super.key});

  @override
  ConsumerState<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends ConsumerState<FavoritosScreen> {
  List<PokemonCardItem> _cards = [];
  bool _loading = true;
  final Set<int> _removingIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFavorites());
  }

  Future<void> _loadFavorites() async {
    final favoriteIds = ref.read(favoriteIdsProvider);
    final notifier = ref.read(favoriteIdsProvider.notifier);
    if (favoriteIds.isEmpty) {
      setState(() {
        _cards = [];
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    final useCase = ref.read(getPokemonDetailUseCaseProvider);
    final cards = <PokemonCardItem>[];
    for (final id in favoriteIds) {
      final slug = notifier.slugForId(id);
      if (slug == null) continue;
      final response = await useCase(GetPokemonDetailParams(slug));
      response.when(
        success: (detail) {
          cards.add(_detailToCard(detail));
        },
        failure: (_, __) {},
      );
    }

    if (!mounted) return;
    setState(() {
      _cards = cards;
      _loading = false;
    });
  }

  static PokemonCardItem _detailToCard(PokemonDetail d) {
    return PokemonCardItem(
      id: d.id,
      number: d.number,
      name: d.name,
      nameSlug: d.nameSlug,
      types: d.typeLabels.map((l) => PokemonTypeTag(label: l)).toList(),
      spriteUrl: d.spriteUrl,
      isFavorite: true,
    );
  }

  static Color _strongColorForTypes(List<String> typeLabels) {
    if (typeLabels.isEmpty) return AppColors.grey9E;
    return PokemonTypeStyle.chipStyle(typeLabels.first).color;
  }

  static List<TypeChipData> _toTypeChipData(
    BuildContext context,
    List<PokemonTypeTag> types,
  ) {
    return types.map((t) {
      final style = PokemonTypeStyle.chipStyle(t.label);
      return TypeChipData(
        label: displayLabelInLocale(context, t.label),
        color: style.color,
        iconPath: style.iconPath,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = ref.watch(favoriteIdsProvider);
    if (favoriteIds.length != _cards.length && !_loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadFavorites());
    }

    final width = MediaQuery.sizeOf(context).width;
    final listPadding = Responsive.listHorizontalPadding(width);
    final itemSpacing = Responsive.listItemSpacing(width);
    final hasData = _cards.isNotEmpty;

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: hasData
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.favoritesTitle),
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurfaceVariant,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: _loading && _cards.isEmpty
            ? _buildLoading(
                context,
                listPadding: listPadding,
                itemSpacing: itemSpacing,
              )
            : _cards.isEmpty
            ? _buildEmptyState(context)
            : _buildList(
                context,
                favoriteIds: favoriteIds,
                listPadding: listPadding,
                itemSpacing: itemSpacing,
              ),
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context, {
    required double listPadding,
    required double itemSpacing,
  }) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: listPadding, vertical: 12),
      itemCount: 8,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: itemSpacing),
        child: PokemonCardSkeleton(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Magikarp_Jump_Pattern_01 1.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.favoritesEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.favoritesEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFromFavorites(PokemonCardItem item) {
    ref
        .read(favoriteIdsProvider.notifier)
        .toggle(item.id, nameSlug: item.nameSlug);
    setState(() => _removingIds.add(item.id));
  }

  void _finishRemoval(PokemonCardItem item) {
    if (!mounted) return;
    setState(() {
      _removingIds.remove(item.id);
      _cards = _cards.where((c) => c.id != item.id).toList();
    });
  }

  Widget _buildList(
    BuildContext context, {
    required Set<int> favoriteIds,
    required double listPadding,
    required double itemSpacing,
  }) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: listPadding, vertical: 12),
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final item = _cards[index];
        final isFav = favoriteIds.contains(item.id);
        final isRemoving = _removingIds.contains(item.id);
        return Padding(
          padding: EdgeInsets.only(bottom: itemSpacing),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              PokemonTypeStyle.cardBorderRadius,
            ),
            child: _SlideOutTile(
              key: ValueKey<int>(item.id),
              isRemoving: isRemoving,
              onComplete: () => _finishRemoval(item),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final actionWidth = constraints.maxWidth * 0.22 + 20;
                  return Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: actionWidth,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.redE5,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                PokemonTypeStyle.cardBorderRadius,
                              ),
                              bottomRight: Radius.circular(
                                PokemonTypeStyle.cardBorderRadius,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Slidable(
                        key: ValueKey<int>(item.id),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.22,
                          children: [
                            CustomSlidableAction(
                              onPressed: (_) => _removeFromFavorites(item),
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.white,
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                  PokemonTypeStyle.cardBorderRadius,
                                ),
                                bottomRight: Radius.circular(
                                  PokemonTypeStyle.cardBorderRadius,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svgs/Interface, Essential/trash-delete-bin-2.svg',
                                  width: 28,
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: PokemonCard(
                          number: item.number,
                          name: item.name,
                          typeChips: _toTypeChipData(context, item.types),
                          spriteUrl: item.spriteUrl,
                          nameSlug: item.nameSlug,
                          heroTagPrefix: 'fav-',
                          isFavorite: isFav,
                          onFavoriteTap: () {
                            ref
                                .read(favoriteIdsProvider.notifier)
                                .toggle(item.id, nameSlug: item.nameSlug);
                            if (isFav) {
                              _removeFromFavorites(item);
                            }
                          },
                          gradient: PokemonTypeStyle.cardGradient(
                            item.types.map((t) => t.label).toList(),
                          ),
                          rightSectionColor: _strongColorForTypes(
                            item.types.map((t) => t.label).toList(),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => PokemonDetailScreen(
                                pokemonName: item.nameSlug,
                                initialHeaderColor: _strongColorForTypes(
                                  item.types.map((t) => t.label).toList(),
                                ),
                                initialSpriteUrl: item.spriteUrl,
                                heroTagPrefix: 'fav-',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SlideOutTile extends StatefulWidget {
  const _SlideOutTile({
    super.key,
    required this.isRemoving,
    required this.onComplete,
    required this.child,
  });

  final bool isRemoving;
  final VoidCallback onComplete;
  final Widget child;

  @override
  State<_SlideOutTile> createState() => _SlideOutTileState();
}

class _SlideOutTileState extends State<_SlideOutTile>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 350);

  late AnimationController _controller;
  late Animation<double> _slide;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _slide = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(_SlideOutTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRemoving && !oldWidget.isRemoving) {
      _controller.forward(from: 0).then((_) => widget.onComplete());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final dx = -_slide.value * (constraints.maxWidth + 24);
            return Transform.translate(
              offset: Offset(dx, 0),
              child: Opacity(opacity: _opacity.value, child: child),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}
