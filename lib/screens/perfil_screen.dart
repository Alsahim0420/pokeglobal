import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/presentation/providers/settings_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _SectionTitle(title: 'Apariencia'),
            const SizedBox(height: 4),
            _ThemeSegment(
              value: themeMode,
              onChanged: (mode) =>
                  ref.read(themeModeProvider.notifier).setThemeMode(mode),
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: 'Idioma'),
            const SizedBox(height: 4),
            _LanguageTile(
              label: 'Español',
              locale: const Locale('es'),
              current: locale,
              onTap: () =>
                  ref.read(localeProvider.notifier).setLocale(const Locale('es')),
            ),
            _LanguageTile(
              label: 'English',
              locale: const Locale('en'),
              current: locale,
              onTap: () =>
                  ref.read(localeProvider.notifier).setLocale(const Locale('en')),
            ),
            _LanguageTile(
              label: 'Sistema',
              locale: null,
              current: locale,
              onTap: () => ref.read(localeProvider.notifier).setLocale(null),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ThemeSegment extends StatefulWidget {
  const _ThemeSegment({
    required this.value,
    required this.onChanged,
  });

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  State<_ThemeSegment> createState() => _ThemeSegmentState();
}

class _ThemeSegmentState extends State<_ThemeSegment>
    with SingleTickerProviderStateMixin {
  static const int _segmentCount = 3;
  static const Duration _slideDuration = Duration(milliseconds: 480);
  static const Duration _scaleDuration = Duration(milliseconds: 380);

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: _scaleDuration,
    );
    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    _scaleController.forward();
  }

  @override
  void didUpdateWidget(_ThemeSegment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _scaleController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  int _indexOf(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 0;
      case ThemeMode.dark:
        return 1;
      case ThemeMode.system:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = widget.value;
    final onChanged = widget.onChanged;
    final selectedIndex = _indexOf(value);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth - 8;
          final segmentWidth = totalWidth / _segmentCount;
          final indicatorLeft = 4 + selectedIndex * segmentWidth + 2;
          final indicatorWidth = segmentWidth - 4;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: _slideDuration,
                curve: Curves.easeOutCubic,
                left: indicatorLeft,
                top: 4,
                bottom: 4,
                width: indicatorWidth,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _SegmentChip(
                    label: 'Claro',
                    icon: Icons.light_mode_outlined,
                    selected: value == ThemeMode.light,
                    onTap: () => onChanged(ThemeMode.light),
                  ),
                  _SegmentChip(
                    label: 'Oscuro',
                    icon: Icons.dark_mode_outlined,
                    selected: value == ThemeMode.dark,
                    onTap: () => onChanged(ThemeMode.dark),
                  ),
                  _SegmentChip(
                    label: 'Sistema',
                    icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    selected: value == ThemeMode.system,
                    onTap: () => onChanged(ThemeMode.system),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: foregroundColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.locale,
    required this.current,
    required this.onTap,
  });

  final String label;
  final Locale? locale;
  final Locale? current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = locale == null ? current == null : current?.languageCode == locale?.languageCode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        label,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary, size: 22)
          : null,
      onTap: onTap,
    );
  }
}
