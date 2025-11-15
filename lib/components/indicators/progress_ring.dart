import 'package:flutter/material.dart';
import 'package:quitter/design_tokens.dart';
import 'dart:math' as math;

/// Circular progress ring that displays around an icon.
///
/// Shows progress as a colored arc with a background ring.
/// Perfect for visualizing weekly/monthly progress on addiction cards.
///
/// Usage:
/// ```dart
/// ProgressRing(
///   progress: 0.75, // 75% complete
///   size: 48,
///   color: Colors.blue,
///   child: Icon(Icons.star),
/// )
/// ```
class ProgressRing extends StatelessWidget {
  /// Progress value from 0.0 (0%) to 1.0 (100%)
  final double progress;

  /// Diameter of the ring in logical pixels
  final double size;

  /// Width of the ring stroke
  final double strokeWidth;

  /// Color of the progress arc
  final Color color;

  /// Widget to display in the center of the ring
  final Widget child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 48,
    this.strokeWidth = 3,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring (full circle)
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              progress: 1.0,
              strokeWidth: strokeWidth,
              color: color.withOpacity(DesignTokens.opacitySubtle * 2),
            ),
          ),
          // Progress ring (partial arc)
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
          // Center content
          child,
        ],
      ),
    );
  }
}

/// Custom painter for drawing the progress ring arc
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw arc from top (-90°) clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
