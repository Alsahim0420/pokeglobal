import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

/// Botón primario reutilizable (azul, texto blanco, bordes redondeados).
/// Usado en onboarding (Continuar/Empecemos) y en vista de error (Reintentar).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.label,
    this.child,
  }) : assert(
         label != null || child != null,
         'Debe indicar label o child',
       );

  final VoidCallback onPressed;
  /// Texto del botón. Se ignora si [child] no es null.
  final String? label;
  /// Contenido custom (ej. AnimatedSwitcher con texto). Si es null se usa [label].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: child ?? Text(label!),
      ),
    );
  }
}
