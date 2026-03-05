import 'package:flutter/material.dart';

/// Colores y gradientes del diseño (Figma). Única fuente de verdad para la paleta.
abstract final class AppColors {
  AppColors._();

  // ─── Blancos y fondos claros ─────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteFafa = Color(0xFFFAFAFA);
  static const Color backgroundLight = Color(0xFFF2F2F2);
  static const Color transparentWhite = Color(0x00FFFFFF);

  // ─── Grises ───────────────────────────────────────────────────────────────
  static const Color greyE0 = Color(0xFFE0E0E0);
  static const Color greyD6 = Color(0xFFD6D6D6);
  static const Color greyEE = Color(0xFFEEEEEE);
  static const Color grey9E = Color(0xFF9E9E9E);
  static const Color grey80 = Color(0xFF808080);
  static const Color grey75 = Color(0xFF757575);
  static const Color grey42 = Color(0xFF424242);
  static const Color grey4D = Color(0xFF4D4D4D);
  static const Color grey33 = Color(0xFF333333);
  static const Color grey12 = Color(0xFF121212);

  // Grises con alpha
  static const Color grey75Alpha60 = Color(0x99757575);
  static const Color grey12Alpha80 = Color(0xCC121212);

  // ─── Azules (primarios / UI) ─────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF007BFF);
  static const Color blue173 = Color(0xFF173EA5);
  static const Color blue456 = Color(0xFF4565B7);
  static const Color blue223 = Color(0xFF223686);
  static const Color blue0D = Color(0xFF0D47A1);
  static const Color blue15 = Color(0xFF1565C0);
  static const Color blue1F = Color(0xFF1F49B6);
  static const Color blue25 = Color(0xFF2551C3);
  static const Color blue1E = Color(0xFF1E88E5);
  static const Color blue3D = Color(0xFF3D8BFF);

  // ─── Verdes ───────────────────────────────────────────────────────────────
  static const Color green8B = Color(0xFF8BC34A);
  static const Color green8BAlpha50 = Color(0x808BC34A);

  // ─── Naranjas ────────────────────────────────────────────────────────────
  static const Color orangeFF = Color(0xFFFF9800);
  static const Color orangeFFAlpha50 = Color(0x80FF9800);

  // ─── Rojos / error ───────────────────────────────────────────────────────
  static const Color redCD = Color(0xFFCD3131);
  static const Color redE5 = Color(0xFFE53935);
  static const Color redF2 = Color(0xFFF22539);
  static const Color redFF = Color(0xFFFF0000);
  static const Color pinkFF = Color(0xFFFF7596);

  // ─── Púrpura / violeta ────────────────────────────────────────────────────
  static const Color purple9C = Color(0xFF9C27B0);
  static const Color purple67 = Color(0xFF673AB7);

  // ─── Cyan ────────────────────────────────────────────────────────────────
  static const Color cyan00 = Color(0xFF00BCD4);

  // ─── Negro / texto ───────────────────────────────────────────────────────
  static const Color black = Color(0xFF000000);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xB3000000); // black87
  static const Color textTertiary = Color(0x8A000000); // black54

  // ─── Skeleton / placeholders ─────────────────────────────────────────────
  static const Color skeletonLight = Color(0xFFE8E8E8);
  static const Color skeletonMid = Color(0xFFD8D8D8);
  static const Color skeletonDark = Color(0xFFD0D0D0);
  static const Color skeletonCircle = Color(0xFFC8C8C8);

  // ─── Gradientes (Figma) ───────────────────────────────────────────────────
  /// linear-gradient(147.44deg, #FFFFFF 0.68%, rgba(255,255,255,0) 101.63%)
  static const LinearGradient gradientWhiteFade147 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, transparentWhite],
  );

  /// linear-gradient(157.23deg, #FFFFFF 0.03%, rgba(255,255,255,0) 99.96%)
  static const LinearGradient gradientWhiteFade157 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, transparentWhite],
  );
}
