// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PokeGlobal';

  @override
  String get navPokedex => 'Pokedex';

  @override
  String get navRegiones => 'Regions';

  @override
  String get navFavoritos => 'Favorites';

  @override
  String get navPerfil => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileLanguageSpanish => 'Spanish';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageSystem => 'System';

  @override
  String get onboardingTitle1 => 'All Pokémon in one place';

  @override
  String get onboardingSubtitle1 =>
      'Access a wide list of Pokémon from all generations created by Nintendo';

  @override
  String get onboardingTitle2 => 'Keep your Pokédex up to date';

  @override
  String get onboardingSubtitle2 =>
      'Sign up and save your profile, favorite Pokémon, settings and much more in the app';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesLoading => 'Loading favorites...';

  @override
  String get favoritesEmptyTitle =>
      'You haven\'t marked any\nPokémon as favorite';

  @override
  String get favoritesEmptySubtitle =>
      'Tap the heart icon on your\nfavorite Pokémon and they will appear here.';

  @override
  String get pokedexSearchHint => 'Search Pokémon...';

  @override
  String get pokedexFilterByType => 'Searching Pokémon by type...';

  @override
  String get pokedexSearching =>
      'Searching your pokedex... Don\'t give up, you\'ll see your Pokémon soon!';

  @override
  String get pokedexNoResults => 'No results';

  @override
  String get pokedexNoPokemon => 'No Pokémon';

  @override
  String get pokedexResultsFound => 'Found ';

  @override
  String pokedexResultsCount(int count) {
    return '$count results';
  }

  @override
  String get pokedexClearFilter => 'Clear filter';

  @override
  String get filterTitle => 'Filter by your preferences';

  @override
  String get filterType => 'Type';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterCancel => 'Cancel';

  @override
  String get regionsComingSoon => 'Coming soon!';

  @override
  String get regionsDescription =>
      'We are working to bring you this section. Come back later to discover all the new features.';

  @override
  String get detailRetry => 'Retry';

  @override
  String get detailWeight => 'WEIGHT';

  @override
  String get detailCategory => 'CATEGORY';

  @override
  String get detailHeight => 'HEIGHT';

  @override
  String get detailAbility => 'ABILITY';

  @override
  String get detailWeaknesses => 'Weaknesses';

  @override
  String get errorTitle => 'Something went wrong...';

  @override
  String get errorMessage =>
      'We couldn\'t load the information right now. Check your connection or try again later.';

  @override
  String get typeNormal => 'Normal';

  @override
  String get typeFire => 'Fire';

  @override
  String get typeWater => 'Water';

  @override
  String get typeElectric => 'Electric';

  @override
  String get typeGrass => 'Grass';

  @override
  String get typeIce => 'Ice';

  @override
  String get typeFighting => 'Fighting';

  @override
  String get typePoison => 'Poison';

  @override
  String get typeGround => 'Ground';

  @override
  String get typeFlying => 'Flying';

  @override
  String get typePsychic => 'Psychic';

  @override
  String get typeBug => 'Bug';

  @override
  String get typeRock => 'Rock';

  @override
  String get typeGhost => 'Ghost';

  @override
  String get typeDragon => 'Dragon';

  @override
  String get typeDark => 'Dark';

  @override
  String get typeSteel => 'Steel';

  @override
  String get typeFairy => 'Fairy';
}
