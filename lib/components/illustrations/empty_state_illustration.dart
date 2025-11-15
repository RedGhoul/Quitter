import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom empty state illustration using CustomPainter.
///
/// Creates a scalable, themeable illustration showing an empty box
/// with floating elements, perfect for "no content yet" states.
///
/// Usage:
/// ```dart
/// EmptyStateIllustration(
///   size: 200,
///   color: Theme.of(context).colorScheme.primary,
/// )
/// ```
class EmptyStateIllustration extends StatefulWidget {
  final double size;
  final Color? color;
  final bool animated;

  const EmptyStateIllustration({
    super.key,
    this.size = 200,
    this.color,
    this.animated = true,
  });

  @override
  State<EmptyStateIllustration> createState() =>
      _EmptyStateIllustrationState();
}

class _EmptyStateIllustrationState extends State<EmptyStateIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animated) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    if (!widget.animated) {
      return CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _EmptyStateIllustrationPainter(
          color: color,
          floatValue: 0,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _EmptyStateIllustrationPainter(
            color: color,
            floatValue: _floatAnimation.value,
          ),
        );
      },
    );
  }
}

class _EmptyStateIllustrationPainter extends CustomPainter {
  final Color color;
  final double floatValue;

  _EmptyStateIllustrationPainter({
    required this.color,
    required this.floatValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Empty box
    _drawBox(canvas, center, size.width * 0.5);

    // Floating elements
    _drawFloatingCircle(canvas, center, size.width * 0.15, -45, 0);
    _drawFloatingCircle(canvas, center, size.width * 0.12, 30, math.pi / 3);
    _drawFloatingCircle(canvas, center, size.width * 0.18, 60, math.pi * 2 / 3);
  }

  void _drawBox(Canvas canvas, Offset center, double boxSize) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Box base
    final rect = Rect.fromCenter(
      center: center + const Offset(0, 10),
      width: boxSize,
      height: boxSize * 0.7,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      borderPaint,
    );

    // Box lid (open)
    final lidPath = Path();
    final lidTop = center.dy - boxSize * 0.4;
    final lidLeft = center.dx - boxSize * 0.6;
    final lidRight = center.dx - boxSize * 0.1;

    lidPath.moveTo(lidLeft, lidTop);
    lidPath.lineTo(lidRight, lidTop - boxSize * 0.1);
    lidPath.lineTo(lidRight, lidTop + boxSize * 0.15);
    lidPath.lineTo(lidLeft, lidTop + boxSize * 0.25);
    lidPath.close();

    canvas.drawPath(lidPath, paint);
    canvas.drawPath(lidPath, borderPaint);

    // Dashed lines indicating emptiness
    _drawDashedCircle(
      canvas,
      center + const Offset(0, 10),
      boxSize * 0.25,
      color.withOpacity(0.2),
    );
  }

  void _drawFloatingCircle(
    Canvas canvas,
    Offset center,
    double radius,
    double angleOffset,
    double phaseOffset,
  ) {
    final float = math.sin(floatValue + phaseOffset) * 10;
    final angle = (floatValue + phaseOffset + angleOffset * math.pi / 180);

    final x = center.dx + math.cos(angle) * radius * 2;
    final y = center.dy + math.sin(angle) * radius * 1.5 + float;

    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(x, y), radius * 0.4, paint);
    canvas.drawCircle(Offset(x, y), radius * 0.4, borderPaint);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashCount = 16;
    const dashLength = math.pi * 2 / dashCount;

    for (int i = 0; i < dashCount; i += 2) {
      final startAngle = i * dashLength;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength * 0.6,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_EmptyStateIllustrationPainter oldDelegate) {
    return oldDelegate.floatValue != floatValue ||
        oldDelegate.color != color;
  }
}

/// Simplified empty state illustration for quick usage
class SimpleEmptyIllustration extends StatelessWidget {
  final double size;
  final Color? color;

  const SimpleEmptyIllustration({
    super.key,
    this.size = 120,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return CustomPaint(
      size: Size(size, size),
      painter: _SimpleEmptyPainter(color: color),
    );
  }
}

class _SimpleEmptyPainter extends CustomPainter {
  final Color color;

  _SimpleEmptyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Outer circle (dashed)
    final dashedPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const dashCount = 12;
    const dashAngle = math.pi * 2 / dashCount;

    for (int i = 0; i < dashCount; i += 2) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * dashAngle,
        dashAngle * 0.7,
        false,
        dashedPaint,
      );
    }

    // Inner elements
    final innerPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final innerBorderPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Three floating rectangles
    _drawFloatingRect(canvas, center, Offset(-radius * 0.3, -radius * 0.2),
        innerPaint, innerBorderPaint);
    _drawFloatingRect(canvas, center, Offset(radius * 0.2, -radius * 0.3),
        innerPaint, innerBorderPaint);
    _drawFloatingRect(canvas, center, Offset(0, radius * 0.3), innerPaint,
        innerBorderPaint);
  }

  void _drawFloatingRect(Canvas canvas, Offset center, Offset offset,
      Paint fillPaint, Paint borderPaint) {
    final rect = Rect.fromCenter(
      center: center + offset,
      width: 20,
      height: 20,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      fillPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(_SimpleEmptyPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
