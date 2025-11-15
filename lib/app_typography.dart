import 'package:flutter/material.dart';

/// Centralized typography system for the Quitter app.
/// Provides consistent text styles across all platforms following
/// Material Design 3 guidelines.
///
/// Usage:
/// ```dart
/// // In main.dart
/// theme: ThemeData(
///   textTheme: AppTypography.getTextTheme(),
/// ),
///
/// // In widgets
/// Text('Hello', style: Theme.of(context).textTheme.titleMedium)
/// ```
class AppTypography {
  AppTypography._();

  /// Returns the complete TextTheme for the app
  static TextTheme getTextTheme() {
    return const TextTheme(
      // ========================================
      // DISPLAY - For hero text and large numbers
      // ========================================
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.22,
      ),

      // ========================================
      // HEADLINES - For section headers
      // ========================================
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      ),

      // ========================================
      // TITLES - For card titles, list headers
      // ========================================
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // ========================================
      // BODY - For main content
      // ========================================
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // ========================================
      // LABELS - For buttons, badges, chips
      // ========================================
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Optional: Returns TextTheme with custom font family
  /// Requires google_fonts package or custom font assets
  ///
  /// Example:
  /// ```dart
  /// textTheme: AppTypography.getTextThemeWithFont('Inter')
  /// ```
  static TextTheme getTextThemeWithFont(String fontFamily) {
    return getTextTheme().apply(fontFamily: fontFamily);
  }
}
