/// Servicio centralizado de rutas a assets SVG.
/// Única fuente de verdad: cambiar nombres de archivos o rutas solo aquí.
/// No depende de Flutter (solo strings), fácil de testear y de usar desde UI.
abstract final class SvgAssetService {
  SvgAssetService._();

  static const String _basePath = 'assets/svgs';

  // ─── Navegación (bottom bar) ─────────────────────────────────────────────
  static const String navPokedex = '$_basePath/icon_nav_pokedex.svg';
  static const String navRegions = '$_basePath/icon_nav_regions.svg';
  static const String navFavorites = '$_basePath/icon_nav_favorites.svg';
  static const String navProfile = '$_basePath/icon_nav_profile.svg';

  /// Rutas de iconos de navegación en orden del bottom bar.
  static const List<String> navIcons = [
    navPokedex,
    navRegions,
    navFavorites,
    navProfile,
  ];

  // ─── Onboarding ──────────────────────────────────────────────────────────
  static const String onboarding1 = '$_basePath/icon_onboarding_1.svg';
  static const String onboarding2 = '$_basePath/icon_onboarding_2.svg';

  // ─── Otros ──────────────────────────────────────────────────────────────
  static const String loader = '$_basePath/icon_loader.svg';

  // ─── Tipos Pokémon (iconos por tipo) ─────────────────────────────────────
  static const String _typePrefix = '$_basePath/icon_type_';

  static const String typeBug = '${_typePrefix}bug.svg';
  static const String typeDark = '${_typePrefix}dark.svg';
  static const String typeDragon = '${_typePrefix}dragon.svg';
  static const String typeElectric = '${_typePrefix}electric.svg';
  static const String typeFairy = '${_typePrefix}fairy.svg';
  static const String typeFighting = '${_typePrefix}fighting.svg';
  static const String typeFire = '${_typePrefix}fire.svg';
  static const String typeFlying = '${_typePrefix}flying.svg';
  static const String typeGhost = '${_typePrefix}ghost.svg';
  static const String typeGrass = '${_typePrefix}grass.svg';
  static const String typeGround = '${_typePrefix}ground.svg';
  static const String typeIce = '${_typePrefix}ice.svg';
  static const String typeNormal = '${_typePrefix}normal.svg';
  static const String typePoison = '${_typePrefix}poison.svg';
  static const String typePsychic = '${_typePrefix}psychic.svg';
  static const String typeRock = '${_typePrefix}rock.svg';
  static const String typeSteel = '${_typePrefix}steel.svg';
  static const String typeWater = '${_typePrefix}water.svg';

  /// Mapa etiqueta (inglés) → ruta. Para etiquetas en español usar [typePathFromLabel].
  static const Map<String, String> _typePathByKey = {
    'bug': typeBug,
    'dark': typeDark,
    'dragon': typeDragon,
    'electric': typeElectric,
    'fairy': typeFairy,
    'fighting': typeFighting,
    'fire': typeFire,
    'flying': typeFlying,
    'ghost': typeGhost,
    'grass': typeGrass,
    'ground': typeGround,
    'ice': typeIce,
    'normal': typeNormal,
    'poison': typePoison,
    'psychic': typePsychic,
    'rock': typeRock,
    'steel': typeSteel,
    'water': typeWater,
  };

  /// Etiquetas en español (o mixtas) a clave interna.
  static const Map<String, String> _labelToKey = {
    'Planta': 'grass',
    'Veneno': 'poison',
    'Fuego': 'fire',
    'Agua': 'water',
    'Eléctrico': 'electric',
    'Electric': 'electric',
    'Bicho': 'bug',
    'Bug': 'bug',
    'Volador': 'flying',
    'Flying': 'flying',
    'Psíquico': 'psychic',
    'Psychic': 'psychic',
    'Roca': 'rock',
    'Rock': 'rock',
    'Tierra': 'ground',
    'Ground': 'ground',
    'Hada': 'fairy',
    'Fairy': 'fairy',
    'Lucha': 'fighting',
    'Fighting': 'fighting',
    'Fantasma': 'ghost',
    'Ghost': 'ghost',
    'Hielo': 'ice',
    'Ice': 'ice',
    'Dragón': 'dragon',
    'Dragon': 'dragon',
    'Siniestro': 'dark',
    'Dark': 'dark',
    'Acero': 'steel',
    'Steel': 'steel',
    'Normal': 'normal',
  };

  /// Devuelve la ruta del SVG del tipo para una etiqueta (ej. "Planta" → icon_type_grass.svg).
  /// Si no hay icono para esa etiqueta, devuelve [typeNormal] como fallback.
  static String typePathFromLabel(String label) {
    final key = _labelToKey[label] ?? label.toLowerCase();
    return _typePathByKey[key] ?? typeNormal;
  }
}
