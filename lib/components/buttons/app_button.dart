import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';
import 'package:quitter/utils/accessibility_utils.dart';

/// Custom button component with press animations and loading states.
///
/// Provides a consistent button experience across the app with:
/// - Scale animation on press
/// - Loading state with spinner
/// - Optional icon
/// - Follows design tokens for animations
///
/// Usage:
/// ```dart
/// AppButton(
///   text: 'Start Journey',
///   icon: Icons.play_arrow,
///   onPressed: () => _handleStart(),
/// )
/// ```
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignTokens.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: DesignTokens.curveStandard,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.isSecondary
        ? FilledButton.tonalIcon(
            onPressed: widget.isLoading ? null : widget.onPressed,
            icon: _buildIcon(),
            label: Text(widget.text),
          )
        : FilledButton.icon(
            onPressed: widget.isLoading ? null : widget.onPressed,
            icon: _buildIcon(),
            label: Text(widget.text),
          );

    final semanticLabel = widget.text;
    final semanticHint = widget.isLoading
        ? 'Loading, please wait'
        : widget.onPressed == null
            ? 'Button is disabled'
            : 'Double tap to activate';

    final semanticButton = AccessibilityUtils.buildSemanticButton(
      label: semanticLabel,
      hint: semanticHint,
      enabled: widget.onPressed != null && !widget.isLoading,
      onTap: widget.onPressed,
      child: button,
    );

    if (widget.onPressed == null || widget.isLoading) {
      return semanticButton;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: semanticButton,
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.isLoading) {
      return SizedBox(
        width: DesignTokens.iconSM,
        height: DesignTokens.iconSM,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: widget.isSecondary
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }

    if (widget.icon != null) {
      return Icon(widget.icon);
    }

    return const SizedBox.shrink();
  }
}
