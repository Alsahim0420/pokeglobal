import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Perfil',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.grey9E,
              ),
        ),
      ),
    );
  }
}
