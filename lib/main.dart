import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/core/env/app_env.dart';
import 'package:pokeglobal/core/theme/app_theme.dart';
import 'package:pokeglobal/gen/l10n/app_localizations.dart';
import 'package:pokeglobal/presentation/providers/favorites_provider.dart';
import 'package:pokeglobal/presentation/providers/settings_provider.dart';
import 'package:pokeglobal/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.init();
  await initFavoritesStorage();
  runApp(const ProviderScope(child: PokeGlobalApp()));
}

class PokeGlobalApp extends ConsumerWidget {
  const PokeGlobalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'PokeGlobal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
