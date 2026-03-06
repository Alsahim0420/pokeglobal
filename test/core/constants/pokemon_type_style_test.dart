import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/constants/pokemon_type_style.dart';

void main() {
  group('PokemonTypeStyle', () {
    test('chipStyle devuelve color y iconPath para tipo conocido', () {
      final style = PokemonTypeStyle.chipStyle('Fuego');
      expect(style.color, isA<Color>());
      expect(style.iconPath, isNotEmpty);
    });

    test('chipStyle usa fallback para tipo desconocido', () {
      final style = PokemonTypeStyle.chipStyle('Desconocido');
      expect(style.color, isA<Color>());
      expect(style.iconPath, isNotEmpty);
    });

    test('cardGradient devuelve LinearGradient para lista con tipos', () {
      final gradient = PokemonTypeStyle.cardGradient(['Planta', 'Veneno']);
      expect(gradient.colors.length, 2);
      expect(gradient.begin, Alignment.centerLeft);
      expect(gradient.end, Alignment.centerRight);
    });

    test('cardGradient maneja lista vacia', () {
      final gradient = PokemonTypeStyle.cardGradient([]);
      expect(gradient.colors, isNotEmpty);
    });

    test('rightSectionColor devuelve Color para primer tipo', () {
      final color = PokemonTypeStyle.rightSectionColor(['Agua']);
      expect(color, isA<Color>());
    });

    test('rightSectionColor maneja lista vacia', () {
      final color = PokemonTypeStyle.rightSectionColor([]);
      expect(color, isA<Color>());
    });

    test('constantes de border radius', () {
      expect(PokemonTypeStyle.cardBorderRadius, 20.0);
      expect(PokemonTypeStyle.rightSectionBorderRadius, 18.0);
    });
  });
}
