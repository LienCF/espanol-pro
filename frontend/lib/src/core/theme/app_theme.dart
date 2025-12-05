import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0D47A1), // Dark Blue from specs
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(fontSize: 57, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.openSans(fontSize: 16),
        bodyMedium: GoogleFonts.openSans(fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0D47A1),
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: GoogleFonts.openSans(fontSize: 16, color: Colors.white70),
        bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.white70),
      ),
    );
  }
}
