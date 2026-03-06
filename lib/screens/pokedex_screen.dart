import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';
import 'package:pokeglobal/core/utils/responsive.dart';
import 'package:pokeglobal/models/pokemon_card_item.dart';
import 'package:pokeglobal/models/pokemon_list_result.dart';
import 'package:pokeglobal/domain/usecases/enrich_pokemon_list_use_case.dart';
import 'package:pokeglobal/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokeglobal/presentation/providers/pokemon_list_provider.dart';
import 'package:pokeglobal/screens/pokemon_detail_screen.dart';
import 'package:pokeglobal/widgets/filter_type_modal.dart';
import 'package:pokeglobal/widgets/primary_button.dart';
import 'package:pokeglobal/widgets/pokemon_card.dart';
import 'package:pokeglobal/widgets/pokemon_card_skeleton.dart';

class PokedexScreen extends ConsumerStatefulWidget {
  const PokedexScreen({super.key});

  @override
  ConsumerState<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends ConsumerState<PokedexScreen> {
  static const int _pageSize = 20;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<PokemonCardItem> _pokemonList = [];
  int? _totalCount;
  bool _loading = true;
  bool _loadingMore = false;
  String? _errorMessage;
  final Set<int> _favoriteIds = {};

  /// Lista completa para búsqueda global (precargada en segundo plano o al buscar).
  List<PokemonCardItem>? _searchFullList;
  bool _loadingFullSearch = false;
  bool _enrichingSearchResults = false;

  /// Filtro por tipo (lupa): lista obtenida de la API /type para todos los Pokémon del tipo.
  List<PokemonCardItem>? _filteredByTypeList;
  bool _loadingFilterByType = false;
  List<String> _selectedFilterTypes = [];

  @override
  void initState() {
    super.initState();
    _loadPokemonList();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _searchFullList = null;
      _enrichingSearchResults = false;
    } else if (_searchFullList == null &&
        !_loadingFullSearch &&
        _totalCount != null) {
      _loadFullSearch();
    } else if (_searchFullList != null &&
        !_loadingFullSearch &&
        !_enrichingSearchResults) {
      _enrichAndShowSearchResults();
    }
    setState(() {});
  }

  void _onScroll() {
    if (_totalCount == null || _loadingMore || _loading) return;
    if (_filteredByTypeList != null) return;
    if (_searchController.text.trim().isNotEmpty) return;
    if (_pokemonList.length >= _totalCount!) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 400) _loadMore();
  }

  Future<void> _openFilterByTypeModal(BuildContext context) async {
    final selected = await showFilterTypeModal(
      context,
      initialSelected: _selectedFilterTypes,
    );
    if (selected == null || !mounted) return;
    _selectedFilterTypes = selected;
    if (selected.isEmpty) {
      setState(() => _filteredByTypeList = null);
      return;
    }
    setState(() => _loadingFilterByType = true);
    final useCase = ref.read(getPokemonListByTypesUseCaseProvider);
    final response = await useCase(selected);
    if (!mounted) return;
    response.when(
      success: (list) async {
        // Enriquecer con tipos reales (API) para mostrar todos los tipos y color del principal
        final enrichUseCase = ref.read(enrichPokemonListUseCaseProvider);
        final enrichResponse = await enrichUseCase(EnrichPokemonListParams(items: list));
        if (!mounted) return;
        enrichResponse.when(
          success: (enrichedList) {
            setState(() {
              _filteredByTypeList = enrichedList
                  .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
                  .toList();
              _loadingFilterByType = false;
            });
          },
          failure: (_, __) {
            setState(() {
              _filteredByTypeList = list
                  .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
                  .toList();
              _loadingFilterByType = false;
            });
          },
        );
      },
      failure: (_, __) {
        setState(() => _loadingFilterByType = false);
      },
    );
  }

  /// Lista a mostrar: si hay filtro por tipo usa [_filteredByTypeList]; si no, [_pokemonList] o [_searchFullList].
  /// Luego se filtra por el texto del buscador (nombre, número o slug).
  List<PokemonCardItem> get _displayedList {
    final query = _searchController.text.trim().toLowerCase();
    final List<PokemonCardItem> source;
    if (_filteredByTypeList != null) {
      source = _filteredByTypeList!;
    } else if (query.isEmpty) {
      return _pokemonList;
    } else {
      source = _searchFullList ?? _pokemonList;
    }
    if (query.isEmpty) return source;
    return source.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.number.toLowerCase().contains(query) ||
          p.nameSlug.toLowerCase().contains(query);
    }).toList();
  }

  /// Precarga la lista completa en segundo plano para que la primera búsqueda sea rápida.
  Future<void> _preloadFullSearch() async {
    if (_totalCount == null || _searchFullList != null || !mounted) return;

    final useCase = ref.read(getPokemonListUseCaseProvider);
    final params = GetPokemonListParams(
      limit: _totalCount!,
      offset: 0,
      enrich: false,
    );
    final response = await useCase(params);

    if (!mounted) return;
    response.when(
      success: (result) {
        setState(() {
          _searchFullList = result.list
              .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
              .toList();
        });
      },
      failure: (_, __) {},
    );
  }

  /// Cuando ya tenemos la lista precargada: enriquece los visibles y muestra con colores.
  Future<void> _enrichAndShowSearchResults() async {
    final displayed = _displayedList;
    if (displayed.isEmpty || _searchFullList == null) return;
    if (displayed.every((p) => p.types.isNotEmpty)) return;

    setState(() => _enrichingSearchResults = true);

    final enrichUseCase = ref.read(enrichPokemonListUseCaseProvider);
    final enrichResponse = await enrichUseCase(
      EnrichPokemonListParams(items: displayed),
    );

    if (!mounted || _searchFullList == null) {
      setState(() => _enrichingSearchResults = false);
      return;
    }
    enrichResponse.when(
      success: (enriched) {
        final withFavorites = enriched
            .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
            .toList();
        final byId = {for (var e in withFavorites) e.id: e};
        final updated = _searchFullList!.map((p) => byId[p.id] ?? p).toList();
        setState(() {
          _searchFullList = updated;
          _enrichingSearchResults = false;
        });
      },
      failure: (_, __) {
        setState(() => _enrichingSearchResults = false);
      },
    );
  }

  /// Carga la lista completa y enriquece los resultados visibles antes de mostrar (colores de una).
  Future<void> _loadFullSearch() async {
    if (_totalCount == null || _loadingFullSearch || !mounted) return;
    setState(() => _loadingFullSearch = true);

    final useCase = ref.read(getPokemonListUseCaseProvider);
    final params = GetPokemonListParams(
      limit: _totalCount!,
      offset: 0,
      enrich: false,
    );
    final response = await useCase(params);

    if (!mounted) return;
    response.when(
      success: (result) => _applyFullSearchResult(result),
      failure: (_, __) {
        setState(() => _loadingFullSearch = false);
      },
    );
  }

  /// Aplica el resultado de búsqueda global: enriquece los ítems que coinciden con la query
  /// y luego actualiza la lista para que las cards salgan ya con colores.
  Future<void> _applyFullSearchResult(PokemonListResult result) async {
    var list = result.list
        .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
        .toList();

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      final toEnrich = list.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.number.toLowerCase().contains(query) ||
            p.nameSlug.toLowerCase().contains(query);
      }).toList();

      if (toEnrich.isNotEmpty) {
        final enrichUseCase = ref.read(enrichPokemonListUseCaseProvider);
        final enrichResponse = await enrichUseCase(
          EnrichPokemonListParams(items: toEnrich),
        );
        enrichResponse.when(
          success: (enriched) {
            final withFavorites = enriched
                .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
                .toList();
            final byId = {for (var e in withFavorites) e.id: e};
            list = list.map((p) => byId[p.id] ?? p).toList();
          },
          failure: (_, __) {},
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _searchFullList = list;
      _loadingFullSearch = false;
    });
  }

  Future<void> _loadPokemonList() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final useCase = ref.read(getPokemonListUseCaseProvider);
    const params = GetPokemonListParams(limit: _pageSize, offset: 0);
    final response = await useCase(params);

    if (!mounted) return;
    response.when(
      success: (result) {
        setState(() {
          _pokemonList = result.list
              .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)))
              .toList();
          _totalCount = result.totalCount;
          _loading = false;
          _errorMessage = null;
        });
        _preloadFullSearch();
      },
      failure: (message, _) {
        setState(() {
          _errorMessage = message;
          _loading = false;
        });
      },
    );
  }

  Future<void> _loadMore() async {
    if (!mounted || _totalCount == null) return;
    if (_pokemonList.length >= _totalCount!) return;
    if (_loadingMore) return;
    setState(() => _loadingMore = true);

    final useCase = ref.read(getPokemonListUseCaseProvider);
    final params = GetPokemonListParams(
      limit: _pageSize,
      offset: _pokemonList.length,
    );
    final response = await useCase(params);

    if (!mounted) return;
    response.when(
      success: (result) {
        setState(() {
          final merged = [
            ..._pokemonList,
            ...result.list.map(
              (p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id)),
            ),
          ];
          _pokemonList = merged;
          _loadingMore = false;
        });
      },
      failure: (_, __) {
        setState(() => _loadingMore = false);
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
      final isFav = _favoriteIds.contains(id);
      _pokemonList = _pokemonList
          .map((p) => p.id == id ? p.copyWith(isFavorite: isFav) : p)
          .toList();
      if (_searchFullList != null) {
        _searchFullList = _searchFullList!
            .map((p) => p.id == id ? p.copyWith(isFavorite: isFav) : p)
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
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
    if (_loadingFilterByType) {
      return KeyedSubtree(
        key: const ValueKey('filter_loading'),
        child: _BouncingPokeballLoading(
          message: 'Buscando Pokémon por tipo...',
        ),
      );
    }

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

    if (_errorMessage != null) {
      return KeyedSubtree(
        key: const ValueKey('error'),
        child: _PokedexErrorView(onRetry: _loadPokemonList),
      );
    }

    final displayed = _displayedList;
    final isSearching = _searchController.text.trim().isNotEmpty;
    final showSearching =
        isSearching && (_loadingFullSearch || _enrichingSearchResults);

    if (displayed.isEmpty || _enrichingSearchResults) {
      return KeyedSubtree(
        key: const ValueKey('empty'),
        child: Center(
          child: showSearching
              ? _BouncingPokeballLoading(
                  message:
                      'Buscando en tu pokedex... ¡No te desesperes pronto veras tus pokemones!',
                )
              : Text(
                  isSearching ? 'No hay resultados' : 'No hay Pokémon',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey75, fontSize: 16),
                ),
        ),
      );
    }

    final showLoadingMore = !isSearching && _loadingMore;
    final itemCount = displayed.length + (showLoadingMore ? 1 : 0);

    return KeyedSubtree(
      key: const ValueKey('list'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearching)
            _buildFilterBanner(context, displayed.length, listPadding),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: listPadding,
                vertical: 12,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index >= displayed.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: itemSpacing),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.grey75,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final item = displayed[index];
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
                    rightSectionColor: _strongColorForTypes(
                      item.types.map((t) => t.label).toList(),
                    ),
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder<void>(
                        pageBuilder: (_, __, ___) => PokemonDetailScreen(
                          pokemonName: item.nameSlug,
                          initialHeaderColor: _strongColorForTypes(
                            item.types.map((t) => t.label).toList(),
                          ),
                          initialSpriteUrl: item.spriteUrl,
                        ),
                        transitionDuration: const Duration(milliseconds: 400),
                        reverseTransitionDuration: const Duration(
                          milliseconds: 350,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                                child: child,
                              );
                            },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBanner(
    BuildContext context,
    int resultCount,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 4),
      child: Row(
        children: [
          Text(
            'Se han encontrado ',
            style: TextStyle(color: AppColors.grey75, fontSize: 14),
          ),
          Text(
            '$resultCount resultados',
            style: TextStyle(
              color: AppColors.grey42,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              _searchFullList = null;
              setState(() {});
            },
            child: Text(
              'Borrar filtro',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
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
              onTap: () => _openFilterByTypeModal(context),
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

/// Indicador de carga con pokeball que rebota hacia los lados (suelo invisible).
class _BouncingPokeballLoading extends StatefulWidget {
  const _BouncingPokeballLoading({required this.message});

  final String message;

  @override
  State<_BouncingPokeballLoading> createState() =>
      _BouncingPokeballLoadingState();
}

class _BouncingPokeballLoadingState extends State<_BouncingPokeballLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * math.pi;
        final dx = 32.0 * math.sin(t);
        final dy = -9.0 * (1 + math.cos(2 * t));
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(dx, dy),
              child: SvgPicture.asset(
                'assets/svgs/iconoir_pokeball.svg',
                width: 48,
                height: 48,
                colorFilter: ColorFilter.mode(
                  AppColors.grey42,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey75, fontSize: 16),
            ),
          ],
        );
      },
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
