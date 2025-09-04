import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Professional e-commerce color palette
  static const Color primaryColor = Color(0xFF2563EB); // Clean blue
  static const Color primaryVariant = Color(0xFF1E40AF);
  static const Color secondary = Color(0xFF10B981); // Success green
  static const Color secondaryVariant = Color(0xFF059669);
  static const Color accent = Color(0xFF7C3AED); // Purple accent
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightError = error;
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.white;
  static const Color lightOnBackground = Color(0xFF1F2937);
  static const Color lightOnSurface = Color(0xFF1F2937);
  static const Color lightOnSurfaceVariant = Color(0xFF6B7280);
  static const Color lightOnError = Colors.white;
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Colors.white;
  static const Color darkOnSecondary = Colors.white;
  static const Color darkOnBackground = Color(0xFFE1E1E1);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);
  static const Color darkOnError = Colors.black;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryVariant,
      secondary: secondary,
      secondaryContainer: secondaryVariant,
      background: lightBackground,
      surface: lightSurface,
      error: lightError,
      onPrimary: lightOnPrimary,
      onSecondary: lightOnSecondary,
      onBackground: lightOnBackground,
      onSurface: lightOnSurface,
      onError: lightOnError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: lightOnSurface,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      shadowColor: primaryColor.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        color: lightOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: lightSurfaceVariant, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: lightOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: lightOnPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: lightOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryVariant,
      secondary: secondary,
      secondaryContainer: secondaryVariant,
      background: darkBackground,
      surface: darkSurface,
      error: darkError,
      onPrimary: darkOnPrimary,
      onSecondary: darkOnSecondary,
      onBackground: darkOnBackground,
      onSurface: darkOnSurface,
      onError: darkOnError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkOnSurface,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      centerTitle: true,
      shadowColor: primaryColor.withOpacity(0.2),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        color: darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: darkSurfaceVariant, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: darkOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: darkOnPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    ),
  );
}
