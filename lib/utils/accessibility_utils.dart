import 'package:flutter/material.dart';

/// Accessibility utilities for ensuring WCAG compliance and screen reader support.
///
/// Provides helpers for:
/// - Semantic labeling
/// - Color contrast checking
/// - Focus management
/// - Screen reader announcements
///
/// Usage:
/// ```dart
/// // Check color contrast
/// final isAccessible = AccessibilityUtils.meetsContrastRatio(
///   foreground: Colors.white,
///   background: Colors.blue,
/// );
///
/// // Build semantic button
/// AccessibilityUtils.buildSemanticButton(
///   label: 'Start tracking',
///   hint: 'Double tap to begin tracking your quit journey',
///   child: MyButton(),
/// );
/// ```
class AccessibilityUtils {
  AccessibilityUtils._();

  /// WCAG AA minimum contrast ratio for normal text
  static const double minContrastRatioNormal = 4.5;

  /// WCAG AA minimum contrast ratio for large text (18pt+ or 14pt+ bold)
  static const double minContrastRatioLarge = 3.0;

  /// WCAG AAA minimum contrast ratio for normal text
  static const double minContrastRatioAAANormal = 7.0;

  /// WCAG AAA minimum contrast ratio for large text
  static const double minContrastRatioAAALarge = 4.5;

  /// Calculate relative luminance of a color (WCAG formula)
  static double _calculateLuminance(Color color) {
    // Normalize RGB values to 0-1 range
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;

    // Apply gamma correction
    r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    // Calculate relative luminance
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors (WCAG formula)
  ///
  /// Returns a value between 1 and 21, where:
  /// - 1 = no contrast (same color)
  /// - 21 = maximum contrast (black on white)
  static double calculateContrastRatio({
    required Color foreground,
    required Color background,
  }) {
    final l1 = _calculateLuminance(foreground);
    final l2 = _calculateLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if two colors meet WCAG AA contrast ratio for normal text (4.5:1)
  static bool meetsContrastRatio({
    required Color foreground,
    required Color background,
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(
      foreground: foreground,
      background: background,
    );

    return isLargeText
        ? ratio >= minContrastRatioLarge
        : ratio >= minContrastRatioNormal;
  }

  /// Check if two colors meet WCAG AAA contrast ratio
  static bool meetsContrastRatioAAA({
    required Color foreground,
    required Color background,
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(
      foreground: foreground,
      background: background,
    );

    return isLargeText
        ? ratio >= minContrastRatioAAALarge
        : ratio >= minContrastRatioAAANormal;
  }

  /// Build a semantic button wrapper with proper labels and hints
  static Widget buildSemanticButton({
    required String label,
    String? hint,
    required Widget child,
    bool enabled = true,
    bool isInMutuallyExclusiveGroup = false,
    bool isChecked = false,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      inMutuallyExclusiveGroup: isInMutuallyExclusiveGroup,
      checked: isInMutuallyExclusiveGroup ? isChecked : null,
      onTap: onTap,
      child: ExcludeSemantics(child: child),
    );
  }

  /// Build a semantic card wrapper with proper navigation labels
  static Widget buildSemanticCard({
    required String label,
    String? value,
    String? hint,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      value: value,
      hint: hint,
      button: onTap != null,
      onTap: onTap,
      child: ExcludeSemantics(child: child),
    );
  }

  /// Build semantic counter/statistic display
  static Widget buildSemanticStat({
    required String label,
    required String value,
    String? hint,
    required Widget child,
  }) {
    return Semantics(
      label: label,
      value: value,
      hint: hint,
      readOnly: true,
      child: ExcludeSemantics(child: child),
    );
  }

  /// Build semantic progress indicator
  static Widget buildSemanticProgress({
    required String label,
    required double progress,
    String? hint,
    required Widget child,
  }) {
    final percentage = (progress * 100).round();
    return Semantics(
      label: label,
      value: '$percentage percent',
      hint: hint,
      readOnly: true,
      child: ExcludeSemantics(child: child),
    );
  }

  /// Build semantic toggle/switch
  static Widget buildSemanticToggle({
    required String label,
    required bool value,
    String? hint,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      value: value ? 'On' : 'Off',
      hint: hint,
      toggled: value,
      onTap: onTap,
      child: ExcludeSemantics(child: child),
    );
  }

  /// Announce a message to screen readers
  static void announce(
    BuildContext context,
    String message, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    SemanticsService.announce(message, textDirection);
  }

  /// Announce a milestone achievement to screen readers
  static void announceMilestone(
    BuildContext context,
    String milestone,
  ) {
    announce(
      context,
      'Achievement unlocked: $milestone',
    );
  }

  /// Get suggested focus order for a widget
  static FocusOrder getFocusOrder(int index) {
    return NumericFocusOrder(index.toDouble());
  }

  /// Check if reduced motion is preferred (system setting)
  static bool isReducedMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get appropriate animation duration based on reduced motion setting
  static Duration getAnimationDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    return isReducedMotionEnabled(context)
        ? Duration.zero
        : normalDuration;
  }

  /// Check if large text is enabled (system setting)
  static bool isLargeTextEnabled(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return textScaleFactor > 1.3;
  }

  /// Get text scale factor from system
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Build semantic header for sections
  static Widget buildSemanticHeader({
    required String text,
    required Widget child,
    int level = 1,
  }) {
    return Semantics(
      header: true,
      label: text,
      sortKey: OrdinalSortKey(0),
      child: ExcludeSemantics(child: child),
    );
  }

  /// Build semantic list item
  static Widget buildSemanticListItem({
    required String label,
    String? value,
    required int index,
    required int totalItems,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      value: value,
      hint: 'Item $index of $totalItems',
      button: onTap != null,
      onTap: onTap,
      sortKey: OrdinalSortKey(index.toDouble()),
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Extension for quick math operations
double pow(double base, double exponent) {
  if (exponent == 0) return 1;
  if (exponent == 1) return base;

  double result = base;
  for (int i = 1; i < exponent; i++) {
    result *= base;
  }
  return result;
}
