import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/core/services/svg_asset_service.dart';
import 'package:pokeglobal/screens/favoritos_screen.dart';
import 'package:pokeglobal/screens/perfil_screen.dart';
import 'package:pokeglobal/screens/pokedex_screen.dart';
import 'package:pokeglobal/screens/regiones_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<String> _navLabels = [
    'Pokedex',
    'Regiones',
    'Favoritos',
    'Perfil',
  ];

  final List<Widget> _screens = const [
    PokedexScreen(),
    RegionesScreen(),
    FavoritosScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const selectedColor = AppColors.blue173;
    const unselectedColor = AppColors.grey9E;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            elevation: 10,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            items: List.generate(
              SvgAssetService.navIcons.length,
              (index) => BottomNavigationBarItem(
                icon: _NavIcon(
                  assetPath: SvgAssetService.navIcons[index],
                  color: _currentIndex == index
                      ? selectedColor
                      : unselectedColor,
                ),
                label: _navLabels[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.assetPath, required this.color});

  final String assetPath;
  final Color color;

  static const double size = 24;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
