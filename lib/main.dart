import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeglobal/screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PokeGlobalApp(),
    ),
  );
}

class PokeGlobalApp extends StatelessWidget {
  const PokeGlobalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeGlobal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
