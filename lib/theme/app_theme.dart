import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color offWhite = Color(0xFFF7F4EE);
  static const Color slate = Color(0xFF39434D);
  static const Color deepNavy = Color(0xFF10243A);
  static const Color mutedBronze = Color(0xFF9A7A3D);
  static const Color softGray = Color(0xFFE2E0DA);
  static const Color paper = Color(0xFFFFFCF6);

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: deepNavy,
      onPrimary: Colors.white,
      secondary: mutedBronze,
      onSecondary: Colors.white,
      error: Color(0xFF8A3A32),
      onError: Colors.white,
      surface: paper,
      onSurface: slate,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: offWhite,
      fontFamily: 'Arial',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: offWhite,
        foregroundColor: deepNavy,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: softGray),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: deepNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepNavy,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: softGray),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          color: deepNavy,
          fontFamily: 'Georgia',
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.08,
        ),
        headlineMedium: const TextStyle(
          color: deepNavy,
          fontFamily: 'Georgia',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.16,
        ),
        titleLarge: const TextStyle(
          color: deepNavy,
          fontFamily: 'Georgia',
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: const TextStyle(
          color: deepNavy,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(color: slate, fontSize: 17, height: 1.5),
        bodyMedium: const TextStyle(color: slate, fontSize: 15, height: 1.45),
        labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
