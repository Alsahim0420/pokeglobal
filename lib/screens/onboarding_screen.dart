import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';
import 'package:pokeglobal/screens/main_shell.dart';
import 'package:pokeglobal/widgets/primary_button.dart';

/// Rutas de las imágenes PNG del onboarding (assets/images/).
const String _onboarding1 = 'assets/images/onboarding_1.png';
const String _onboarding2 = 'assets/images/onboarding_2.png';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      imageAsset: _onboarding1,
      title: 'Todos los Pokémon en un solo lugar',
      subtitle:
          'Accede a una amplia lista de Pokémon de todas las generaciones creadas por Nintendo',
    ),
    _OnboardingPage(
      imageAsset: _onboarding2,
      title: 'Mantén tu Pokédex actualizada',
      subtitle:
          'Regístrate y guarda tu perfil, Pokémon favoritos, configuraciones y mucho más en la aplicación',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _nextOrFinish() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageView(
                    imageAsset: page.imageAsset,
                    title: page.title,
                    subtitle: page.subtitle,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: _PageIndicator(
                count: _pages.length,
                currentIndex: _currentPage,
                activeColor: AppColors.blue173,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: PrimaryButton(
                onPressed: _nextOrFinish,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Empecemos'
                        : 'Continuar',
                    key: ValueKey(_currentPage),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(child: Image.asset(imageAsset, fit: BoxFit.contain)),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.grey42,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
  });

  final int count;
  final int currentIndex;
  final Color activeColor;

  static const double _dotHeight = 8;
  static const double _activeDotWidth = 24;
  static const double _inactiveDotWidth = 8;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? _activeDotWidth : _inactiveDotWidth,
          height: _dotHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_dotHeight / 2),
            color: isActive ? activeColor : AppColors.greyE0,
          ),
        );
      }),
    );
  }
}
