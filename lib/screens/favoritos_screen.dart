import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/utils/responsive.dart';
import 'package:pokeglobal/domain/entities/pokemon_detail.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/providers/pokemon_detail_provider.dart';
import 'package:pokeglobal/screens/pokemon_detail_screen.dart';
import 'package:pokeglobal/widgets/pokemon_card.dart';

class FavoritosScreen extends ConsumerStatefulWidget {
  const FavoritosScreen({super.key});

  @override
  ConsumerState<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends ConsumerState<FavoritosScreen> {
  List<PokemonCardItem> _cards = [];
  bool _loading = true;

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

  static List<TypeChipData> _toTypeChipData(List<PokemonTypeTag> types) {
    return types.map((t) {
      final style = PokemonTypeStyle.chipStyle(t.label);
      return TypeChipData(
        label: t.label,
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

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: hasData
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Favoritos'),
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.grey42,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: _loading && _cards.isEmpty
            ? _buildLoading()
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

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryBlue),
          const SizedBox(height: 16),
          Text(
            'Cargando favoritos...',
            style: TextStyle(color: AppColors.grey75, fontSize: 16),
          ),
        ],
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
              'No has marcado ningún\nPokémon como favorito',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Haz clic en el ícono de corazón de tus\nPokémon favoritos y aparecerán aquí.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey75,
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
    setState(() {
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
        return Padding(
          padding: EdgeInsets.only(bottom: itemSpacing),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              PokemonTypeStyle.cardBorderRadius,
            ),
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
                        typeChips: _toTypeChipData(item.types),
                        spriteUrl: item.spriteUrl,
                        nameSlug: item.nameSlug,
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
        );
      },
    );
  }
}
