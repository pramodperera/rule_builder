import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,

  // Material 3 color system derived from a seed color (clean & modern)
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB), // modern blue
    brightness: Brightness.light,
  ),

  // App-wide typography feel
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 14, height: 1.35),
  ),

  // Better looking cards
  cardTheme: CardThemeData(
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // Better buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),

  // Better inputs
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black.withOpacity(0.04),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  ),

  scaffoldBackgroundColor: const Color(0xFFF7F8FA), // soft background
);
