import 'package:flutter/material.dart';

/// Design tokens for consistent spacing, sizing, and timing
/// across the Quitter app.
///
/// Usage:
/// ```dart
/// padding: EdgeInsets.all(DesignTokens.space4)
/// borderRadius: BorderRadius.circular(DesignTokens.radiusMD)
/// duration: DesignTokens.durationNormal
/// ```
class DesignTokens {
  // Prevent instantiation
  DesignTokens._();

  // ============================================================
  // SPACING - Based on 8pt grid system
  // ============================================================

  /// 0dp - No spacing
  static const double space0 = 0;

  /// 4dp - Minimal spacing
  static const double space1 = 4;

  /// 8dp - Tight spacing
  static const double space2 = 8;

  /// 12dp - Compact spacing
  static const double space3 = 12;

  /// 16dp - Standard spacing (most common)
  static const double space4 = 16;

  /// 20dp - Comfortable spacing
  static const double space5 = 20;

  /// 24dp - Large spacing
  static const double space6 = 24;

  /// 32dp - Extra large spacing
  static const double space8 = 32;

  /// 40dp - Double extra large
  static const double space10 = 40;

  /// 48dp - Triple extra large
  static const double space12 = 48;

  /// 64dp - Massive spacing
  static const double space16 = 64;

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  /// 4dp - Extra small radius
  static const double radiusXS = 4;

  /// 8dp - Small radius
  static const double radiusSM = 8;

  /// 12dp - Medium radius
  static const double radiusMD = 12;

  /// 16dp - Large radius
  static const double radiusLG = 16;

  /// 20dp - Extra large radius
  static const double radiusXL = 20;

  /// 24dp - Double extra large radius
  static const double radius2XL = 24;

  /// 999dp - Pill/fully rounded
  static const double radiusRound = 999;

  // ============================================================
  // ELEVATION (Material Design 3)
  // ============================================================

  /// Level 0 - Flat surface
  static const double elevation0 = 0;

  /// Level 1 - Subtle elevation
  static const double elevation1 = 1;

  /// Level 2 - Raised elements
  static const double elevation2 = 2;

  /// Level 3 - Menus and dropdowns
  static const double elevation3 = 4;

  /// Level 4 - Dialogs
  static const double elevation4 = 6;

  /// Level 5 - Modals
  static const double elevation5 = 8;

  // ============================================================
  // ANIMATION DURATIONS
  // ============================================================

  /// 150ms - Fast animations (micro-interactions)
  static const Duration durationFast = Duration(milliseconds: 150);

  /// 250ms - Normal animations (most transitions)
  static const Duration durationNormal = Duration(milliseconds: 250);

  /// 350ms - Slow animations (emphasized transitions)
  static const Duration durationSlow = Duration(milliseconds: 350);

  /// 500ms - Slower animations (page transitions)
  static const Duration durationSlower = Duration(milliseconds: 500);

  /// 2500ms - Celebration animations (confetti)
  static const Duration durationCelebration = Duration(milliseconds: 2500);

  // ============================================================
  // ANIMATION CURVES
  // ============================================================

  /// Standard easing for most animations
  static const Curve curveStandard = Curves.easeInOut;

  /// Decelerate (ease out) for entering elements
  static const Curve curveDecelerate = Curves.easeOut;

  /// Accelerate (ease in) for exiting elements
  static const Curve curveAccelerate = Curves.easeIn;

  /// Emphasized motion for important transitions
  static const Curve curveEmphasized = Curves.easeInOutCubic;

  // ============================================================
  // ICON SIZES
  // ============================================================

  /// 16dp - Extra small icons
  static const double iconXS = 16;

  /// 20dp - Small icons
  static const double iconSM = 20;

  /// 24dp - Standard icons (default)
  static const double iconMD = 24;

  /// 32dp - Large icons
  static const double iconLG = 32;

  /// 48dp - Extra large icons
  static const double iconXL = 48;

  /// 64dp - Hero icons
  static const double icon2XL = 64;

  // ============================================================
  // LAYOUT CONSTRAINTS
  // ============================================================

  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48;

  /// Maximum content width for wide screens
  static const double maxContentWidth = 1200;

  /// Comfortable reading width
  static const double maxReadingWidth = 720;

  // ============================================================
  // OPACITY VALUES
  // ============================================================

  /// 38% - Disabled state
  static const double opacityDisabled = 0.38;

  /// 60% - Medium emphasis text
  static const double opacityMediumEmphasis = 0.60;

  /// 87% - High emphasis text
  static const double opacityHighEmphasis = 0.87;

  /// 10% - Subtle background tints
  static const double opacitySubtle = 0.10;

  /// 30% - Overlays and shadows
  static const double opacityLight = 0.30;

  /// 90% - Semi-transparent surfaces
  static const double opacitySemiTransparent = 0.90;

  // ============================================================
  // ACCESSIBILITY HELPERS
  // ============================================================

  /// Get animation duration with reduced motion support
  ///
  /// Returns Duration.zero if reduced motion is enabled in system settings,
  /// otherwise returns the specified duration.
  ///
  /// Usage:
  /// ```dart
  /// AnimationController(
  ///   duration: DesignTokens.getDuration(context, DesignTokens.durationNormal),
  ///   vsync: this,
  /// );
  /// ```
  static Duration getDuration(BuildContext context, Duration normal) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return reducedMotion ? Duration.zero : normal;
  }

  /// Get fast animation duration with reduced motion support
  static Duration getDurationFast(BuildContext context) {
    return getDuration(context, durationFast);
  }

  /// Get normal animation duration with reduced motion support
  static Duration getDurationNormal(BuildContext context) {
    return getDuration(context, durationNormal);
  }

  /// Get slow animation duration with reduced motion support
  static Duration getDurationSlow(BuildContext context) {
    return getDuration(context, durationSlow);
  }

  /// Get slower animation duration with reduced motion support
  static Duration getDurationSlower(BuildContext context) {
    return getDuration(context, durationSlower);
  }

  /// Get celebration animation duration with reduced motion support
  static Duration getDurationCelebration(BuildContext context) {
    return getDuration(context, durationCelebration);
  }

  /// Check if reduced motion is enabled (system setting)
  static bool isReducedMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get text scale factor from system accessibility settings
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Check if large text is enabled (text scale > 1.3x)
  static bool isLargeTextEnabled(BuildContext context) {
    return getTextScaleFactor(context) > 1.3;
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }
}
