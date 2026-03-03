import 'package:flutter/material.dart';
import 'package:pokeglobal/screens/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _primaryBlue = Color(0xFF007BFF);
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      imageAsset: 'assets/images/onboarding_1.png',
      title: 'Todos los Pokémon en un solo lugar',
      subtitle:
          'Accede a una amplia lista de Pokémon de todas las generaciones creadas por Nintendo',
    ),
    _OnboardingPage(
      imageAsset: 'assets/images/onboarding_2.png',
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
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'PokeGlobal'),
        ),
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
      backgroundColor: Colors.white,
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
                activeColor: _primaryBlue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextOrFinish,
                  style: FilledButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Empecemos' : 'Continuar',
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
            child: Center(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
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
            color: isActive ? activeColor : Colors.grey.shade300,
          ),
        );
      }),
    );
  }
}
