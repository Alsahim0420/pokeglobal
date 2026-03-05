import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/utils/responsive.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokeglobal/presentation/providers/pokemon_list_provider.dart';
import 'package:pokeglobal/widgets/primary_button.dart';
import 'package:pokeglobal/widgets/pokemon_card.dart';
import 'package:pokeglobal/widgets/pokemon_card_skeleton.dart';

class PokedexScreen extends ConsumerStatefulWidget {
  const PokedexScreen({super.key});

  @override
  ConsumerState<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends ConsumerState<PokedexScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PokemonCardItem> _pokemonList = [];
  bool _loading = true;
  String? _errorMessage;
  final Set<int> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadPokemonList();
  }

  Future<void> _loadPokemonList() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final useCase = ref.read(getPokemonListUseCaseProvider);
    const params = GetPokemonListParams(limit: 20, offset: 0);
    final response = await useCase(params);

    if (!mounted) return;
    response.when(
      success: (list) {
        setState(() {
          _pokemonList = list
              .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
              .toList();
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

  void _toggleFavorite(int id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
      _pokemonList = _pokemonList
          .map(
            (p) => p.id == id
                ? p.copyWith(isFavorite: _favoriteIds.contains(id))
                : p,
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final listPadding = Responsive.listHorizontalPadding(width);
    final itemSpacing = Responsive.listItemSpacing(width);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildBody(listPadding, itemSpacing),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(double listPadding, double itemSpacing) {
    if (_loading) {
      return KeyedSubtree(
        key: const ValueKey('loading'),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: listPadding, vertical: 12),
          itemCount: 10,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: itemSpacing),
            child: PokemonCardSkeleton(),
          ),
        ),
      );
    }

    if (_errorMessage == null) {
      return KeyedSubtree(
        key: const ValueKey('error'),
        child: _PokedexErrorView(onRetry: _loadPokemonList),
      );
    }

    if (_pokemonList.isEmpty) {
      return KeyedSubtree(
        key: const ValueKey('empty'),
        child: Center(
          child: Text(
            'No hay Pokémon',
            style: TextStyle(color: AppColors.grey75, fontSize: 16),
          ),
        ),
      );
    }

    return KeyedSubtree(
      key: const ValueKey('list'),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: listPadding, vertical: 12),
        itemCount: _pokemonList.length,
        itemBuilder: (context, index) {
          final item = _pokemonList[index];
          return Padding(
            padding: EdgeInsets.only(bottom: itemSpacing),
            child: PokemonCard(
              number: item.number,
              name: item.name,
              typeChips: _toTypeChipData(item.types),
              spriteUrl: item.spriteUrl,
              nameSlug: item.nameSlug,
              isFavorite: item.isFavorite,
              onFavoriteTap: () => _toggleFavorite(item.id),
              gradient: PokemonTypeStyle.cardGradient(
                item.types.map((t) => t.label).toList(),
              ),
              rightSectionColor: PokemonTypeStyle.rightSectionColor(
                item.types.map((t) => t.label).toList(),
              ),
            ),
          );
        },
      ),
    );
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

  Widget _buildSearchBar(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = Responsive.searchBarHorizontalPadding(width);
    final searchBarHeight = (48.0 * (width / 400).clamp(0.9, 1.15))
        .roundToDouble();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: searchBarHeight,
              decoration: BoxDecoration(
                color: AppColors.transparentWhite,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.greyE0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Procurar Pókemon...',
                  hintStyle: TextStyle(color: AppColors.grey9E),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.grey9E,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: width * 0.025),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.transparentWhite,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.greyE0),
                ),
                width: searchBarHeight,
                height: searchBarHeight,
                child: const Icon(
                  Icons.search_rounded,
                  color: AppColors.grey9E,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vista de error cuando falla la carga de Pokémon (Magikarp + mensaje + Reintentar).
class _PokedexErrorView extends StatelessWidget {
  const _PokedexErrorView({required this.onRetry});

  final VoidCallback onRetry;

  static const String _magikarpAsset =
      'assets/images/Magikarp_Jump_Pattern_01 1.png';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _magikarpAsset,
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: AppColors.grey9E,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Algo salió mal...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey33,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No pudimos cargar la información en este momento. '
              'Verifica tu conexión o intenta nuevamente más tarde.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey42),
            ),
            const SizedBox(height: 32),
            PrimaryButton(onPressed: onRetry, label: 'Reintentar'),
          ],
        ),
      ),
    );
  }
}
