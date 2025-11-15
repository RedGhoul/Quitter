import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';

/// Custom page transitions for consistent navigation animations.
///
/// Provides several transition styles:
/// - Fade through transition (Material Design 3)
/// - Slide transition
/// - Scale transition
/// - Shared axis transition
///
/// Usage:
/// ```dart
/// Navigator.of(context).push(
///   PageTransitions.fadeThrough(builder: (_) => NewPage()),
/// );
/// ```
class PageTransitions {
  PageTransitions._();

  /// Fade through transition - current page fades out, new page fades in
  ///
  /// This is the recommended Material Design 3 transition for
  /// parent-child navigation.
  static PageRoute<T> fadeThrough<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: DesignTokens.durationNormal,
      reverseTransitionDuration: DesignTokens.durationNormal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade out
        final fadeOut = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
        ));

        // Scale down slightly
        final scaleOut = Tween<double>(
          begin: 1.0,
          end: 0.92,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
        ));

        // Fade in
        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
        ));

        return Stack(
          children: [
            // Exiting page
            if (secondaryAnimation.status != AnimationStatus.dismissed)
              FadeTransition(
                opacity: fadeOut,
                child: ScaleTransition(
                  scale: scaleOut,
                  child: Container(),
                ),
              ),
            // Entering page
            FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          ],
        );
      },
    );
  }

  /// Slide transition - new page slides in from right
  ///
  /// Good for sibling navigation or forward flow.
  static PageRoute<T> slideFromRight<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: DesignTokens.durationNormal,
      reverseTransitionDuration: DesignTokens.durationNormal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: DesignTokens.curveEmphasized)),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Scale transition - new page scales up from center
  ///
  /// Good for opening detail views or modals.
  static PageRoute<T> scaleUp<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: DesignTokens.durationNormal,
      reverseTransitionDuration: DesignTokens.durationFast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: DesignTokens.curveEmphasized,
        ));

        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5),
        ));

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }

  /// Shared axis transition - horizontal slide with fade
  ///
  /// Material Design 3 transition for switching between
  /// peer pages (like tabs).
  static PageRoute<T> sharedAxisHorizontal<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: DesignTokens.durationNormal,
      reverseTransitionDuration: DesignTokens.durationNormal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(0.1, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: DesignTokens.curveDecelerate,
        ));

        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.1, 0.0),
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: DesignTokens.curveAccelerate,
        ));

        final fadeIn = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0),
        ));

        final fadeOut = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.0, 0.3),
        ));

        return Stack(
          children: [
            // Exiting page
            if (secondaryAnimation.status != AnimationStatus.dismissed)
              FadeTransition(
                opacity: fadeOut,
                child: SlideTransition(
                  position: slideOut,
                  child: Container(),
                ),
              ),
            // Entering page
            FadeTransition(
              opacity: fadeIn,
              child: SlideTransition(
                position: slideIn,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
