import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

void main() {
  group('AppColors', () {
    test('colores base definidos', () {
      expect(AppColors.white, isA<Color>());
      expect(AppColors.black, isA<Color>());
      expect(AppColors.primaryBlue, isA<Color>());
      expect(AppColors.transparentWhite, isA<Color>());
    });

    test('grises definidos', () {
      expect(AppColors.grey9E, isA<Color>());
      expect(AppColors.greyE0, isA<Color>());
      expect(AppColors.greyD6, isA<Color>());
    });

    test('typeIconBackGradient devuelve LinearGradient', () {
      final g = AppColors.typeIconBackGradient;
      expect(g.colors.length, 4);
      expect(g.stops, [0.0, 0.35, 0.65, 1.0]);
    });
  });
}
