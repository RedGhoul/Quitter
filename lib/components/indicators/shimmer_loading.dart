import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';

/// Shimmer loading effect for skeleton screens.
///
/// Creates an animated shimmer gradient that moves across the widget.
/// Perfect for loading states while content is being fetched.
///
/// Usage:
/// ```dart
/// ShimmerLoading(
///   child: Container(
///     width: double.infinity,
///     height: 200,
///     color: Colors.white,
///   ),
/// )
/// ```
class ShimmerLoading extends StatefulWidget {
  /// The widget to apply the shimmer effect to
  final Widget child;

  /// Base color of the shimmer (defaults to theme surfaceVariant)
  final Color? baseColor;

  /// Highlight color of the shimmer (defaults to theme surface)
  final Color? highlightColor;

  /// Duration of one shimmer cycle
  final Duration? duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor =
        widget.highlightColor ?? Theme.of(context).colorScheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton card for loading states.
///
/// Pre-built skeleton that mimics a QuitCard layout.
///
/// Usage:
/// ```dart
/// if (isLoading)
///   ShimmerLoadingSkeleton()
/// else
///   QuitCard(...)
/// ```
class ShimmerLoadingSkeleton extends StatelessWidget {
  const ShimmerLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.space5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: DesignTokens.iconXL + DesignTokens.space6,
              height: DesignTokens.iconXL + DesignTokens.space6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
              ),
            ),
            const SizedBox(height: DesignTokens.space4),
            // Title placeholder
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
              ),
            ),
            const SizedBox(height: DesignTokens.space2),
            // Days placeholder
            Container(
              width: 80,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
              ),
            ),
            const SizedBox(height: DesignTokens.space4),
            // Date placeholder
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
