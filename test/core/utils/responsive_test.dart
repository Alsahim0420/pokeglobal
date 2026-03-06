import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/utils/responsive.dart';

void main() {
  group('Responsive', () {
    test('baseCardHeight es 108', () {
      expect(Responsive.baseCardHeight, 108.0);
    });

    test('cardHeight clamp entre 90 y 100', () {
      final h1 = Responsive.cardHeight(300);
      expect(h1, greaterThanOrEqualTo(90.0));
      expect(h1, lessThanOrEqualTo(100.0));
      final h2 = Responsive.cardHeight(500);
      expect(h2, greaterThanOrEqualTo(90.0));
      expect(h2, lessThanOrEqualTo(100.0));
    });

    test('cardScale es cardHeight / baseCardHeight', () {
      final h = Responsive.cardHeight(400);
      expect(Responsive.cardScale(400), h / 108.0);
    });

    test('listHorizontalPadding clamp entre 16 y 28', () {
      final p1 = Responsive.listHorizontalPadding(200);
      expect(p1, greaterThanOrEqualTo(16.0));
      expect(p1, lessThanOrEqualTo(28.0));
      final p2 = Responsive.listHorizontalPadding(800);
      expect(p2, greaterThanOrEqualTo(16.0));
      expect(p2, lessThanOrEqualTo(28.0));
    });

    test('searchBarHorizontalPadding igual a listHorizontalPadding', () {
      const w = 350.0;
      expect(
        Responsive.searchBarHorizontalPadding(w),
        Responsive.listHorizontalPadding(w),
      );
    });

    test('listItemSpacing clamp entre 8 y 14', () {
      final s = Responsive.listItemSpacing(300);
      expect(s, greaterThanOrEqualTo(8.0));
      expect(s, lessThanOrEqualTo(14.0));
    });
  });
}
