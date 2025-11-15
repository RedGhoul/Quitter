import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Haptic feedback utilities for tactile responses.
///
/// Provides consistent haptic feedback across the app for:
/// - Light touches (selection)
/// - Medium impacts (actions)
/// - Heavy impacts (important actions)
/// - Success/error feedback
///
/// Only works on mobile platforms (iOS/Android).
class HapticUtils {
  HapticUtils._();

  /// Light haptic feedback for selections and minor interactions
  ///
  /// Use for:
  /// - Tab selection
  /// - Toggle switches
  /// - Picker scrolling
  static Future<void> light() async {
    if (!_isMobile) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Medium haptic feedback for standard interactions
  ///
  /// Use for:
  /// - Button presses
  /// - List item selections
  /// - Standard confirmations
  static Future<void> medium() async {
    if (!_isMobile) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Heavy haptic feedback for important interactions
  ///
  /// Use for:
  /// - Delete confirmations
  /// - Major state changes
  /// - Important alerts
  static Future<void> heavy() async {
    if (!_isMobile) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Success haptic pattern (light + medium)
  ///
  /// Use for:
  /// - Successful actions
  /// - Achievements unlocked
  /// - Goals reached
  static Future<void> success() async {
    if (!_isMobile) return;
    try {
      await HapticFeedback.selectionClick();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Error haptic pattern (heavy vibration)
  ///
  /// Use for:
  /// - Failed actions
  /// - Validation errors
  /// - Important warnings
  static Future<void> error() async {
    if (!_isMobile) return;
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Celebration haptic pattern (multiple light touches)
  ///
  /// Use for:
  /// - Milestone achievements
  /// - Starting quit journey
  /// - Major accomplishments
  static Future<void> celebration() async {
    if (!_isMobile) return;
    try {
      for (int i = 0; i < 3; i++) {
        await HapticFeedback.selectionClick();
        await Future.delayed(const Duration(milliseconds: 100));
      }
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Check if device supports haptic feedback
  static bool get _isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  /// Check if haptics are available on this platform
  static bool get isAvailable => _isMobile;
}
