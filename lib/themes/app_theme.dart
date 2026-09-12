import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get emeraldTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF006E4A), // Deep Emerald
        onPrimary: Color(0xFFFFFFFF), // Text on primary
        primaryContainer: Color(0xFFA4F4CF), // Soft emerald container
        onPrimaryContainer: Color(0xFF002114), // Text on container

        secondary: Color(0xFF4C6356), // Muted emerald grey
        onSecondary: Color(0xFFFFFFFF), // Text on secondary

        surface: Color(0xFFF6FBF7), // Off-white emerald tint
        onSurface: Color(0xFF191C1A), // Surface text
        surfaceContainer: Color(0xFFECFDF5), // Card background
        surfaceContainerLow: Color(0xFFF0F5F1), // Card background more faded
        onSurfaceVariant: Color(0xFF404943), // Secundary text / icons

        outline: Color(0xFF707973), // Visible margins
        outlineVariant: Color(0xFFC0C9C2), // Subtle outlines (around cards)

        error: Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
      ),
    );
  }
}
