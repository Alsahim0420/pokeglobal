import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Favoritos',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.grey9E,
              ),
        ),
      ),
    );
  }
}
