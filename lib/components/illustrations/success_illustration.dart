import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom success/celebration illustration using CustomPainter.
///
/// Creates a scalable, themeable illustration showing celebration elements
/// like stars, checkmarks, and sparkles. Perfect for achievement unlocks,
/// milestone celebrations, and success states.
///
/// Usage:
/// ```dart
/// SuccessIllustration(
///   size: 200,
///   color: Theme.of(context).colorScheme.primary,
///   type: SuccessIllustrationType.achievement,
/// )
/// ```
class SuccessIllustration extends StatefulWidget {
  final double size;
  final Color? color;
  final bool animated;
  final SuccessIllustrationType type;

  const SuccessIllustration({
    super.key,
    this.size = 200,
    this.color,
    this.animated = true,
    this.type = SuccessIllustrationType.checkmark,
  });

  @override
  State<SuccessIllustration> createState() => _SuccessIllustrationState();
}

enum SuccessIllustrationType {
  checkmark, // Checkmark with sparkles
  trophy, // Trophy with stars
  achievement, // Star burst
}

class _SuccessIllustrationState extends State<SuccessIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    if (widget.animated) {
      _controller.repeat(reverse: true);
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
        painter: _SuccessIllustrationPainter(
          color: color,
          scale: 1.0,
          rotation: 0,
          type: widget.type,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SuccessIllustrationPainter(
            color: color,
            scale: _scaleAnimation.value,
            rotation: _rotateAnimation.value,
            type: widget.type,
          ),
        );
      },
    );
  }
}

class _SuccessIllustrationPainter extends CustomPainter {
  final Color color;
  final double scale;
  final double rotation;
  final SuccessIllustrationType type;

  _SuccessIllustrationPainter({
    required this.color,
    required this.scale,
    required this.rotation,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (type) {
      case SuccessIllustrationType.checkmark:
        _drawCheckmark(canvas, center, size.width * 0.35, scale);
        _drawSparkles(canvas, center, size.width * 0.45, rotation);
        break;
      case SuccessIllustrationType.trophy:
        _drawTrophy(canvas, center, size.width * 0.35);
        _drawStars(canvas, center, size.width * 0.45, rotation);
        break;
      case SuccessIllustrationType.achievement:
        _drawStarBurst(canvas, center, size.width * 0.4, scale, rotation);
        break;
    }
  }

  void _drawCheckmark(Canvas canvas, Offset center, double size, double scale) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Circle background
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawCircle(center, size, paint);
    canvas.drawCircle(center, size, borderPaint);

    // Checkmark
    final checkPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(center.dx - size * 0.4, center.dy);
    path.lineTo(center.dx - size * 0.1, center.dy + size * 0.35);
    path.lineTo(center.dx + size * 0.5, center.dy - size * 0.35);

    canvas.drawPath(path, checkPaint);

    canvas.restore();
  }

  void _drawSparkles(
      Canvas canvas, Offset center, double radius, double rotation) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // 4 sparkles at cardinal points
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final sparkleX = math.cos(angle) * radius;
      final sparkleY = math.sin(angle) * radius;

      _drawSparkle(canvas, Offset(sparkleX, sparkleY), 12, paint);
    }

    canvas.restore();
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    // 4-pointed star
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 4;
      final outerX = center.dx + math.cos(angle) * size;
      final outerY = center.dy + math.sin(angle) * size;

      final innerAngle = angle + math.pi / 4;
      final innerX = center.dx + math.cos(innerAngle) * (size * 0.4);
      final innerY = center.dy + math.sin(innerAngle) * (size * 0.4);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTrophy(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Trophy cup
    final cupPath = Path();
    final cupWidth = size * 0.8;
    final cupHeight = size * 0.7;

    cupPath.moveTo(center.dx - cupWidth * 0.4, center.dy - cupHeight * 0.3);
    cupPath.lineTo(center.dx - cupWidth * 0.5, center.dy + cupHeight * 0.3);
    cupPath.lineTo(center.dx + cupWidth * 0.5, center.dy + cupHeight * 0.3);
    cupPath.lineTo(center.dx + cupWidth * 0.4, center.dy - cupHeight * 0.3);
    cupPath.close();

    canvas.drawPath(cupPath, paint);
    canvas.drawPath(cupPath, borderPaint);

    // Handles
    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Left handle
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(center.dx - cupWidth * 0.55, center.dy - cupHeight * 0.1),
        radius: cupWidth * 0.2,
      ),
      -math.pi / 2,
      math.pi,
      false,
      handlePaint,
    );

    // Right handle
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(center.dx + cupWidth * 0.55, center.dy - cupHeight * 0.1),
        radius: cupWidth * 0.2,
      ),
      -math.pi / 2,
      -math.pi,
      false,
      handlePaint,
    );

    // Base
    final basePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + cupHeight * 0.5),
          width: cupWidth * 0.6,
          height: 6,
        ),
        const Radius.circular(3),
      ),
      basePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + cupHeight * 0.6),
          width: cupWidth * 0.8,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      basePaint,
    );
  }

  void _drawStars(Canvas canvas, Offset center, double radius, double rotation) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 0.5);

    // 6 stars in circle
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final starX = math.cos(angle) * radius;
      final starY = math.sin(angle) * radius;

      _drawStar(canvas, Offset(starX, starY), 8, 5, paint);
    }

    canvas.restore();
  }

  void _drawStar(
      Canvas canvas, Offset center, double outerRadius, int points, Paint paint) {
    final path = Path();
    final innerRadius = outerRadius * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStarBurst(Canvas canvas, Offset center, double size, double scale,
      double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.rotate(rotation * 0.3);

    // Main star
    final starPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final starBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    _drawStar(canvas, Offset.zero, size, 8, starPaint);
    _drawStar(canvas, Offset.zero, size, 8, starBorderPaint);

    // Inner glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(Offset.zero, size * 0.4, glowPaint);

    // Radiating lines
    final linePaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6);
      final startRadius = size * 1.1;
      final endRadius = size * 1.4;

      canvas.drawLine(
        Offset(
          math.cos(angle) * startRadius,
          math.sin(angle) * startRadius,
        ),
        Offset(
          math.cos(angle) * endRadius,
          math.sin(angle) * endRadius,
        ),
        linePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SuccessIllustrationPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.rotation != rotation ||
        oldDelegate.color != color ||
        oldDelegate.type != type;
  }
}

/// Simplified success checkmark for inline usage
class SimpleSuccessIllustration extends StatelessWidget {
  final double size;
  final Color? color;

  const SimpleSuccessIllustration({
    super.key,
    this.size = 60,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return CustomPaint(
      size: Size(size, size),
      painter: _SimpleSuccessPainter(color: color),
    );
  }
}

class _SimpleSuccessPainter extends CustomPainter {
  final Color color;

  _SimpleSuccessPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Circle
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, borderPaint);

    // Checkmark
    final checkPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(center.dx - radius * 0.4, center.dy);
    path.lineTo(center.dx - radius * 0.1, center.dy + radius * 0.3);
    path.lineTo(center.dx + radius * 0.45, center.dy - radius * 0.3);

    canvas.drawPath(path, checkPaint);
  }

  @override
  bool shouldRepaint(_SimpleSuccessPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
