import 'package:flutter/material.dart';
import 'package:pokeglobal/core/constants/app_colors.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.blue173,
        onPrimary: AppColors.white,
        secondary: AppColors.blue456,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.textDark,
        onSurfaceVariant: AppColors.grey75,
        surfaceContainerHighest: AppColors.greyF2,
        error: AppColors.redE5,
        onError: AppColors.white,
        outline: AppColors.greyDD,
        shadow: AppColors.black,
        inverseSurface: AppColors.grey12,
        onInverseSurface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.grey42,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.blue173,
        unselectedItemColor: AppColors.grey9E,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        textColor: AppColors.textDark,
        iconColor: AppColors.grey42,
      ),
      dividerColor: AppColors.greyE0,
      textTheme: _textTheme(AppColors.textDark, AppColors.grey75),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.blue3D,
        onPrimary: AppColors.grey12,
        secondary: AppColors.blue456,
        onSecondary: AppColors.white,
        surface: AppColors.grey12,
        onSurface: AppColors.white,
        onSurfaceVariant: AppColors.grey9E,
        surfaceContainerHighest: AppColors.grey33,
        error: AppColors.redE5,
        onError: AppColors.white,
        outline: AppColors.grey4D,
        shadow: AppColors.black,
        inverseSurface: AppColors.greyF2,
        onInverseSurface: AppColors.grey12,
      ),
      scaffoldBackgroundColor: AppColors.grey12,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.grey12,
        foregroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.grey12,
        selectedItemColor: AppColors.blue3D,
        unselectedItemColor: AppColors.grey9E,
      ),
      cardTheme: CardThemeData(
        color: AppColors.grey33,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.white,
        iconColor: AppColors.grey9E,
      ),
      dividerColor: AppColors.grey4D,
      textTheme: _textTheme(AppColors.white, AppColors.grey9E),
    );
  }

  static TextTheme _textTheme(Color bodyColor, Color secondaryColor) {
    return TextTheme(
      titleLarge: TextStyle(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(color: bodyColor, fontSize: 16),
      bodyMedium: TextStyle(color: bodyColor, fontSize: 14),
      bodySmall: TextStyle(color: secondaryColor, fontSize: 12),
      labelLarge: TextStyle(color: bodyColor, fontWeight: FontWeight.w600),
    );
  }
}
