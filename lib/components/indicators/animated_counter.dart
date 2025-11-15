import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';

/// Animated counter that smoothly transitions between number values.
///
/// Perfect for displaying changing metrics like days clean, streak counts, etc.
/// Numbers count up/down with a smooth animation.
///
/// Usage:
/// ```dart
/// AnimatedCounter(
///   value: daysClean,
///   style: Theme.of(context).textTheme.headlineSmall,
/// )
/// ```
class AnimatedCounter extends StatefulWidget {
  /// The numeric value to display
  final int value;

  /// Text style for the number
  final TextStyle? style;

  /// Duration of the counting animation
  final Duration? duration;

  /// Optional prefix text (e.g., "$")
  final String? prefix;

  /// Optional suffix text (e.g., "days")
  final String? suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration,
    this.prefix,
    this.suffix,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? DesignTokens.durationNormal,
      vsync: this,
    );
    _previousValue = widget.value;
    _setupAnimation();
  }

  void _setupAnimation() {
    _animation = IntTween(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: DesignTokens.curveDecelerate,
    ));
    _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _controller.duration = widget.duration ?? DesignTokens.durationNormal;
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final text = StringBuffer();
        if (widget.prefix != null) text.write(widget.prefix);
        text.write('${_animation.value}');
        if (widget.suffix != null) text.write(widget.suffix);

        return Text(
          text.toString(),
          style: widget.style,
        );
      },
    );
  }
}
