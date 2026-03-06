import 'package:flutter/material.dart';
import 'package:pokeglobal/core/services/pokemon_type_label_mapper.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';

/// Devuelve el nombre del tipo para la UI según el idioma actual.
String typeLabel(BuildContext context, String apiTypeName) {
  final l10n = AppLocalizations.of(context)!;
  final key = apiTypeName.toLowerCase();
  switch (key) {
    case 'normal':
      return l10n.typeNormal;
    case 'fire':
      return l10n.typeFire;
    case 'water':
      return l10n.typeWater;
    case 'electric':
      return l10n.typeElectric;
    case 'grass':
      return l10n.typeGrass;
    case 'ice':
      return l10n.typeIce;
    case 'fighting':
      return l10n.typeFighting;
    case 'poison':
      return l10n.typePoison;
    case 'ground':
      return l10n.typeGround;
    case 'flying':
      return l10n.typeFlying;
    case 'psychic':
      return l10n.typePsychic;
    case 'bug':
      return l10n.typeBug;
    case 'rock':
      return l10n.typeRock;
    case 'ghost':
      return l10n.typeGhost;
    case 'dragon':
      return l10n.typeDragon;
    case 'dark':
      return l10n.typeDark;
    case 'steel':
      return l10n.typeSteel;
    case 'fairy':
      return l10n.typeFairy;
    default:
      return apiTypeName;
  }
}

/// Lista de nombres de tipo de la API (para filtros y listados).
const List<String> apiTypeNames = [
  'normal',
  'fire',
  'water',
  'electric',
  'grass',
  'ice',
  'fighting',
  'poison',
  'ground',
  'flying',
  'psychic',
  'bug',
  'rock',
  'ghost',
  'dragon',
  'dark',
  'steel',
  'fairy',
];

/// Convierte un label mostrado en la UI de vuelta al nombre de la API.
String? apiNameFromDisplayLabel(BuildContext context, String displayLabel) {
  for (final api in apiTypeNames) {
    if (typeLabel(context, api) == displayLabel) return api;
  }
  return null;
}

/// Dado un label (p. ej. en español desde la entidad) devuelve el texto en el idioma actual.
String displayLabelInLocale(BuildContext context, String label) {
  final apiName = PokemonTypeLabelMapper.toApiName(label) ?? label.toLowerCase();
  return typeLabel(context, apiName);
}
