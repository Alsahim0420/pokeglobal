import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'PokeGlobal'**
  String get appTitle;

  /// No description provided for @navPokedex.
  ///
  /// In es, this message translates to:
  /// **'Pokedex'**
  String get navPokedex;

  /// No description provided for @navRegiones.
  ///
  /// In es, this message translates to:
  /// **'Regiones'**
  String get navRegiones;

  /// No description provided for @navFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get navFavoritos;

  /// No description provided for @navPerfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navPerfil;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @profileAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get profileAppearance;

  /// No description provided for @profileLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get profileLanguage;

  /// No description provided for @profileThemeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get profileThemeDark;

  /// No description provided for @profileThemeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get profileThemeSystem;

  /// No description provided for @profileLanguageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get profileLanguageSpanish;

  /// No description provided for @profileLanguageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get profileLanguageEnglish;

  /// No description provided for @profileLanguageSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get profileLanguageSystem;

  /// No description provided for @onboardingTitle1.
  ///
  /// In es, this message translates to:
  /// **'Todos los Pokémon en un solo lugar'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In es, this message translates to:
  /// **'Accede a una amplia lista de Pokémon de todas las generaciones creadas por Nintendo'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In es, this message translates to:
  /// **'Mantén tu Pokédex actualizada'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In es, this message translates to:
  /// **'Regístrate y guarda tu perfil, Pokémon favoritos, configuraciones y mucho más en la aplicación'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingStart.
  ///
  /// In es, this message translates to:
  /// **'Empecemos'**
  String get onboardingStart;

  /// No description provided for @onboardingContinue.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get onboardingContinue;

  /// No description provided for @favoritesTitle.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favoritesTitle;

  /// No description provided for @favoritesLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando favoritos...'**
  String get favoritesLoading;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No has marcado ningún\nPokémon como favorito'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Haz clic en el ícono de corazón de tus\nPokémon favoritos y aparecerán aquí.'**
  String get favoritesEmptySubtitle;

  /// No description provided for @pokedexSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar Pokémon...'**
  String get pokedexSearchHint;

  /// No description provided for @pokedexFilterByType.
  ///
  /// In es, this message translates to:
  /// **'Buscando Pokémon por tipo...'**
  String get pokedexFilterByType;

  /// No description provided for @pokedexSearching.
  ///
  /// In es, this message translates to:
  /// **'Buscando en tu pokedex... ¡No te desesperes, pronto verás tus Pokémon!'**
  String get pokedexSearching;

  /// No description provided for @pokedexNoResults.
  ///
  /// In es, this message translates to:
  /// **'No hay resultados'**
  String get pokedexNoResults;

  /// No description provided for @pokedexNoPokemon.
  ///
  /// In es, this message translates to:
  /// **'No hay Pokémon'**
  String get pokedexNoPokemon;

  /// No description provided for @pokedexResultsFound.
  ///
  /// In es, this message translates to:
  /// **'Se han encontrado '**
  String get pokedexResultsFound;

  /// No description provided for @pokedexResultsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} resultados'**
  String pokedexResultsCount(int count);

  /// No description provided for @pokedexClearFilter.
  ///
  /// In es, this message translates to:
  /// **'Borrar filtro'**
  String get pokedexClearFilter;

  /// No description provided for @filterTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtra por tus preferencias'**
  String get filterTitle;

  /// No description provided for @filterType.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get filterType;

  /// No description provided for @filterApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get filterApply;

  /// No description provided for @filterCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get filterCancel;

  /// No description provided for @regionsComingSoon.
  ///
  /// In es, this message translates to:
  /// **'¡Muy pronto disponible!'**
  String get regionsComingSoon;

  /// No description provided for @regionsDescription.
  ///
  /// In es, this message translates to:
  /// **'Estamos trabajando para traerte esta sección. Vuelve más adelante para descubrir todas las novedades.'**
  String get regionsDescription;

  /// No description provided for @detailRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get detailRetry;

  /// No description provided for @detailWeight.
  ///
  /// In es, this message translates to:
  /// **'PESO'**
  String get detailWeight;

  /// No description provided for @detailCategory.
  ///
  /// In es, this message translates to:
  /// **'CATEGORÍA'**
  String get detailCategory;

  /// No description provided for @detailHeight.
  ///
  /// In es, this message translates to:
  /// **'ALTURA'**
  String get detailHeight;

  /// No description provided for @detailAbility.
  ///
  /// In es, this message translates to:
  /// **'HABILIDAD'**
  String get detailAbility;

  /// No description provided for @detailWeaknesses.
  ///
  /// In es, this message translates to:
  /// **'Debilidades'**
  String get detailWeaknesses;

  /// No description provided for @errorTitle.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal...'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la información en este momento. Verifica tu conexión o intenta nuevamente más tarde.'**
  String get errorMessage;

  /// No description provided for @typeNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get typeNormal;

  /// No description provided for @typeFire.
  ///
  /// In es, this message translates to:
  /// **'Fuego'**
  String get typeFire;

  /// No description provided for @typeWater.
  ///
  /// In es, this message translates to:
  /// **'Agua'**
  String get typeWater;

  /// No description provided for @typeElectric.
  ///
  /// In es, this message translates to:
  /// **'Eléctrico'**
  String get typeElectric;

  /// No description provided for @typeGrass.
  ///
  /// In es, this message translates to:
  /// **'Planta'**
  String get typeGrass;

  /// No description provided for @typeIce.
  ///
  /// In es, this message translates to:
  /// **'Hielo'**
  String get typeIce;

  /// No description provided for @typeFighting.
  ///
  /// In es, this message translates to:
  /// **'Lucha'**
  String get typeFighting;

  /// No description provided for @typePoison.
  ///
  /// In es, this message translates to:
  /// **'Veneno'**
  String get typePoison;

  /// No description provided for @typeGround.
  ///
  /// In es, this message translates to:
  /// **'Tierra'**
  String get typeGround;

  /// No description provided for @typeFlying.
  ///
  /// In es, this message translates to:
  /// **'Volador'**
  String get typeFlying;

  /// No description provided for @typePsychic.
  ///
  /// In es, this message translates to:
  /// **'Psíquico'**
  String get typePsychic;

  /// No description provided for @typeBug.
  ///
  /// In es, this message translates to:
  /// **'Bicho'**
  String get typeBug;

  /// No description provided for @typeRock.
  ///
  /// In es, this message translates to:
  /// **'Roca'**
  String get typeRock;

  /// No description provided for @typeGhost.
  ///
  /// In es, this message translates to:
  /// **'Fantasma'**
  String get typeGhost;

  /// No description provided for @typeDragon.
  ///
  /// In es, this message translates to:
  /// **'Dragón'**
  String get typeDragon;

  /// No description provided for @typeDark.
  ///
  /// In es, this message translates to:
  /// **'Siniestro'**
  String get typeDark;

  /// No description provided for @typeSteel.
  ///
  /// In es, this message translates to:
  /// **'Acero'**
  String get typeSteel;

  /// No description provided for @typeFairy.
  ///
  /// In es, this message translates to:
  /// **'Hada'**
  String get typeFairy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
