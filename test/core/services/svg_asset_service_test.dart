import 'package:flutter_test/flutter_test.dart';
import 'package:pokeglobal/core/services/svg_asset_service.dart';

void main() {
  group('SvgAssetService', () {
    test('typePathFromLabel devuelve ruta para etiqueta en español', () {
      expect(
        SvgAssetService.typePathFromLabel('Planta'),
        contains('icon_type_grass'),
      );
      expect(
        SvgAssetService.typePathFromLabel('Fuego'),
        contains('icon_type_fire'),
      );
    });

    test('typePathFromLabel devuelve fallback para etiqueta desconocida', () {
      final path = SvgAssetService.typePathFromLabel('Desconocido');
      expect(path, contains('icon_type_normal'));
    });

    test('navIcons tiene 4 elementos', () {
      expect(SvgAssetService.navIcons.length, 4);
      expect(SvgAssetService.navIcons.first, contains('icon_nav_pokedex'));
    });
  });
}
