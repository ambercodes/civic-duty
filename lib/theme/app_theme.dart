import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final interTextTheme = GoogleFonts.interTextTheme();
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: offWhite,
      textTheme: interTextTheme,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: offWhite,
        foregroundColor: deepNavy,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: deepNavy,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
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
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
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
        displayLarge: GoogleFonts.cormorantGaramond(
          color: deepNavy,
          fontSize: 52,
          fontWeight: FontWeight.w700,
          height: 1,
          letterSpacing: 0,
        ),
        displaySmall: GoogleFonts.cormorantGaramond(
          color: deepNavy,
          fontSize: 44,
          fontWeight: FontWeight.w700,
          height: 1.04,
          letterSpacing: 0,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          color: deepNavy,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.1,
          letterSpacing: 0,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          color: deepNavy,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          height: 1.14,
          letterSpacing: 0,
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          color: deepNavy,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.18,
          letterSpacing: 0,
        ),
        titleMedium: GoogleFonts.inter(
          color: deepNavy,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          height: 1.3,
          letterSpacing: 0,
        ),
        bodyLarge: GoogleFonts.inter(
          color: slate,
          fontSize: 17,
          height: 1.52,
          letterSpacing: 0,
        ),
        bodyMedium: GoogleFonts.inter(
          color: slate,
          fontSize: 15,
          height: 1.48,
          letterSpacing: 0,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
