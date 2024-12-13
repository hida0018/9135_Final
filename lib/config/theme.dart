import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.light,
        primary: const Color(0xFF4CAF50),
        onPrimary: Colors.white,
        secondary: const Color(0xFF81C784),
        onSecondary: Colors.white,
        background: const Color(0xFFE8F5E9),
        onBackground: Colors.black54,
        surface: Colors.white,
        onSurface: Colors.black54,
        error: const Color(0xFFC62828),
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'FiraSans-Bold',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'FiraSans-Medium',
          fontSize: 26,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          fontFamily: 'FiraSans-Regular',
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: 'FiraSans-Regular',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'FiraSans-Regular',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'FiraSans-Italic',
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
