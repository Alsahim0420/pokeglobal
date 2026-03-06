// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PokeGlobal';

  @override
  String get navPokedex => 'Pokedex';

  @override
  String get navRegiones => 'Regiones';

  @override
  String get navFavoritos => 'Favoritos';

  @override
  String get navPerfil => 'Perfil';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileAppearance => 'Apariencia';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileThemeLight => 'Claro';

  @override
  String get profileThemeDark => 'Oscuro';

  @override
  String get profileThemeSystem => 'Sistema';

  @override
  String get profileLanguageSpanish => 'Español';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageSystem => 'Sistema';

  @override
  String get onboardingTitle1 => 'Todos los Pokémon en un solo lugar';

  @override
  String get onboardingSubtitle1 =>
      'Accede a una amplia lista de Pokémon de todas las generaciones creadas por Nintendo';

  @override
  String get onboardingTitle2 => 'Mantén tu Pokédex actualizada';

  @override
  String get onboardingSubtitle2 =>
      'Regístrate y guarda tu perfil, Pokémon favoritos, configuraciones y mucho más en la aplicación';

  @override
  String get onboardingStart => 'Empecemos';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesLoading => 'Cargando favoritos...';

  @override
  String get favoritesEmptyTitle =>
      'No has marcado ningún\nPokémon como favorito';

  @override
  String get favoritesEmptySubtitle =>
      'Haz clic en el ícono de corazón de tus\nPokémon favoritos y aparecerán aquí.';

  @override
  String get pokedexSearchHint => 'Buscar Pokémon...';

  @override
  String get pokedexFilterByType => 'Buscando Pokémon por tipo...';

  @override
  String get pokedexSearching =>
      'Buscando en tu pokedex... ¡No te desesperes, pronto verás tus Pokémon!';

  @override
  String get pokedexNoResults => 'No hay resultados';

  @override
  String get pokedexNoPokemon => 'No hay Pokémon';

  @override
  String get pokedexResultsFound => 'Se han encontrado ';

  @override
  String pokedexResultsCount(int count) {
    return '$count resultados';
  }

  @override
  String get pokedexClearFilter => 'Borrar filtro';

  @override
  String get filterTitle => 'Filtra por tus preferencias';

  @override
  String get filterType => 'Tipo';

  @override
  String get filterApply => 'Aplicar';

  @override
  String get filterCancel => 'Cancelar';

  @override
  String get regionsComingSoon => '¡Muy pronto disponible!';

  @override
  String get regionsDescription =>
      'Estamos trabajando para traerte esta sección. Vuelve más adelante para descubrir todas las novedades.';

  @override
  String get detailRetry => 'Reintentar';

  @override
  String get detailWeight => 'PESO';

  @override
  String get detailCategory => 'CATEGORÍA';

  @override
  String get detailHeight => 'ALTURA';

  @override
  String get detailAbility => 'HABILIDAD';

  @override
  String get detailWeaknesses => 'Debilidades';

  @override
  String get errorTitle => 'Algo salió mal...';

  @override
  String get errorMessage =>
      'No pudimos cargar la información en este momento. Verifica tu conexión o intenta nuevamente más tarde.';

  @override
  String get typeNormal => 'Normal';

  @override
  String get typeFire => 'Fuego';

  @override
  String get typeWater => 'Agua';

  @override
  String get typeElectric => 'Eléctrico';

  @override
  String get typeGrass => 'Planta';

  @override
  String get typeIce => 'Hielo';

  @override
  String get typeFighting => 'Lucha';

  @override
  String get typePoison => 'Veneno';

  @override
  String get typeGround => 'Tierra';

  @override
  String get typeFlying => 'Volador';

  @override
  String get typePsychic => 'Psíquico';

  @override
  String get typeBug => 'Bicho';

  @override
  String get typeRock => 'Roca';

  @override
  String get typeGhost => 'Fantasma';

  @override
  String get typeDragon => 'Dragón';

  @override
  String get typeDark => 'Siniestro';

  @override
  String get typeSteel => 'Acero';

  @override
  String get typeFairy => 'Hada';
}
