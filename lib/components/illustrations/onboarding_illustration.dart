import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom onboarding illustrations using CustomPainter.
///
/// Creates scalable, themeable illustrations for app onboarding screens.
/// Each illustration represents a key feature or benefit of the app.
///
/// Usage:
/// ```dart
/// OnboardingIllustration(
///   size: 300,
///   type: OnboardingIllustrationType.tracking,
///   color: Theme.of(context).colorScheme.primary,
/// )
/// ```
class OnboardingIllustration extends StatefulWidget {
  final double size;
  final Color? color;
  final bool animated;
  final OnboardingIllustrationType type;

  const OnboardingIllustration({
    super.key,
    this.size = 300,
    this.color,
    this.animated = true,
    required this.type,
  });

  @override
  State<OnboardingIllustration> createState() =>
      _OnboardingIllustrationState();
}

enum OnboardingIllustrationType {
  tracking, // Calendar/chart showing progress
  privacy, // Shield/lock for data privacy
  journey, // Path/road showing progress journey
  community, // People/support network
  milestones, // Trophy/achievement unlocking
}

class _OnboardingIllustrationState extends State<OnboardingIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
        painter: _OnboardingIllustrationPainter(
          color: color,
          progress: 0.5,
          type: widget.type,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _OnboardingIllustrationPainter(
            color: color,
            progress: _animation.value,
            type: widget.type,
          ),
        );
      },
    );
  }
}

class _OnboardingIllustrationPainter extends CustomPainter {
  final Color color;
  final double progress;
  final OnboardingIllustrationType type;

  _OnboardingIllustrationPainter({
    required this.color,
    required this.progress,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (type) {
      case OnboardingIllustrationType.tracking:
        _drawTracking(canvas, center, size.width * 0.7);
        break;
      case OnboardingIllustrationType.privacy:
        _drawPrivacy(canvas, center, size.width * 0.6);
        break;
      case OnboardingIllustrationType.journey:
        _drawJourney(canvas, center, size.width * 0.8);
        break;
      case OnboardingIllustrationType.community:
        _drawCommunity(canvas, center, size.width * 0.7);
        break;
      case OnboardingIllustrationType.milestones:
        _drawMilestones(canvas, center, size.width * 0.6);
        break;
    }
  }

  void _drawTracking(Canvas canvas, Offset center, double size) {
    // Calendar/chart background
    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final chartRect = Rect.fromCenter(
      center: center,
      width: size,
      height: size * 0.8,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(chartRect, const Radius.circular(16)),
      bgPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(chartRect, const Radius.circular(16)),
      borderPaint,
    );

    // Grid lines
    final gridPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y =
          chartRect.top + (chartRect.height / 5) * i;
      canvas.drawLine(
        Offset(chartRect.left + 20, y),
        Offset(chartRect.right - 20, y),
        gridPaint,
      );
    }

    // Animated bar chart
    final barPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final barHeights = [0.4, 0.6, 0.3, 0.8, 0.5];
    final barWidth = (chartRect.width - 60) / barHeights.length;

    for (int i = 0; i < barHeights.length; i++) {
      final animatedHeight = barHeights[i] * progress;
      final barHeight = chartRect.height * 0.6 * animatedHeight;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          chartRect.left + 30 + (barWidth * i),
          chartRect.bottom - 30 - barHeight,
          barWidth * 0.6,
          barHeight,
        ),
        const Radius.circular(4),
      );

      canvas.drawRRect(barRect, barPaint);
    }

    // Upward arrow indicator
    if (progress > 0.7) {
      final arrowPaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final arrowPath = Path();
      final arrowX = chartRect.right - 40;
      final arrowY = chartRect.top + 40;

      arrowPath.moveTo(arrowX, arrowY + 20);
      arrowPath.lineTo(arrowX, arrowY);
      arrowPath.lineTo(arrowX - 8, arrowY + 8);
      arrowPath.moveTo(arrowX, arrowY);
      arrowPath.lineTo(arrowX + 8, arrowY + 8);

      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  void _drawPrivacy(Canvas canvas, Offset center, double size) {
    // Shield shape
    final shieldPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final shieldBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final shieldPath = Path();
    shieldPath.moveTo(center.dx, center.dy - size * 0.5); // Top
    shieldPath.lineTo(center.dx + size * 0.4, center.dy - size * 0.3); // Top right
    shieldPath.lineTo(center.dx + size * 0.4, center.dy + size * 0.2); // Right
    shieldPath.quadraticBezierTo(
      center.dx + size * 0.3,
      center.dy + size * 0.5,
      center.dx,
      center.dy + size * 0.6,
    ); // Bottom right curve
    shieldPath.quadraticBezierTo(
      center.dx - size * 0.3,
      center.dy + size * 0.5,
      center.dx - size * 0.4,
      center.dy + size * 0.2,
    ); // Bottom left curve
    shieldPath.lineTo(center.dx - size * 0.4, center.dy - size * 0.3); // Left
    shieldPath.close();

    canvas.drawPath(shieldPath, shieldPaint);
    canvas.drawPath(shieldPath, shieldBorderPaint);

    // Lock icon in center
    final lockPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Lock body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size * 0.1),
          width: size * 0.3,
          height: size * 0.25,
        ),
        const Radius.circular(6),
      ),
      lockPaint..style = PaintingStyle.fill,
    );

    // Lock shackle
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - size * 0.05),
        width: size * 0.25,
        height: size * 0.25,
      ),
      -math.pi,
      math.pi,
      false,
      lockPaint..style = PaintingStyle.stroke,
    );

    // Animated checkmark (appears with progress)
    if (progress > 0.5) {
      final checkPaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final checkPath = Path();
      final checkOpacity = (progress - 0.5) * 2;

      checkPath.moveTo(center.dx - size * 0.12, center.dy + size * 0.1);
      checkPath.lineTo(center.dx - size * 0.05, center.dy + size * 0.17);
      checkPath.lineTo(center.dx + size * 0.12, center.dy + size * 0.03);

      canvas.drawPath(checkPath, checkPaint..color = Colors.green.withOpacity(checkOpacity));
    }

    // Radiating shield effect
    _drawRadiatingCircles(canvas, center, size * 0.5, progress);
  }

  void _drawJourney(Canvas canvas, Offset center, double size) {
    // Winding path
    final pathPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.08
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final startX = center.dx - size * 0.4;
    final startY = center.dy + size * 0.4;

    path.moveTo(startX, startY);

    // Winding S-curve
    path.cubicTo(
      startX + size * 0.2, startY - size * 0.15, // Control point 1
      startX + size * 0.3, startY - size * 0.25, // Control point 2
      startX + size * 0.5, startY - size * 0.3, // End point
    );

    path.cubicTo(
      startX + size * 0.7, startY - size * 0.35, // Control point 1
      startX + size * 0.6, startY - size * 0.5, // Control point 2
      startX + size * 0.8, startY - size * 0.6, // End point
    );

    canvas.drawPath(path, pathPaint);

    // Milestone markers along the path
    _drawMilestoneMarker(canvas, Offset(startX, startY), size * 0.06, color, true);
    _drawMilestoneMarker(
      canvas,
      Offset(startX + size * 0.5, startY - size * 0.3),
      size * 0.06,
      color,
      progress > 0.5,
    );
    _drawMilestoneMarker(
      canvas,
      Offset(startX + size * 0.8, startY - size * 0.6),
      size * 0.06,
      color,
      progress > 0.8,
    );

    // Animated progress dot
    final progressPosition = progress;
    final dotY = startY - size * 0.6 * progressPosition;
    final dotX = startX + size * 0.8 * progressPosition;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), size * 0.05, dotPaint);

    // Glow around progress dot
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(Offset(dotX, dotY), size * 0.08, glowPaint);
  }

  void _drawMilestoneMarker(
    Canvas canvas,
    Offset position,
    double size,
    Color color,
    bool completed,
  ) {
    final paint = Paint()
      ..color = completed ? color : color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = completed ? color : color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(position, size, paint);
    canvas.drawCircle(position, size, borderPaint);

    if (completed) {
      // Inner dot
      canvas.drawCircle(position, size * 0.4, Paint()..color = Colors.white);
    }
  }

  void _drawCommunity(Canvas canvas, Offset center, double size) {
    // Three overlapping circles representing people
    final personPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final personBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final personSize = size * 0.25;

    // Draw three people in triangle formation
    final positions = [
      Offset(center.dx, center.dy - size * 0.2), // Top
      Offset(center.dx - size * 0.25, center.dy + size * 0.15), // Bottom left
      Offset(center.dx + size * 0.25, center.dy + size * 0.15), // Bottom right
    ];

    for (final pos in positions) {
      // Head
      canvas.drawCircle(
        Offset(pos.dx, pos.dy - personSize * 0.3),
        personSize * 0.3,
        personPaint,
      );
      canvas.drawCircle(
        Offset(pos.dx, pos.dy - personSize * 0.3),
        personSize * 0.3,
        personBorderPaint,
      );

      // Body (semi-circle)
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(pos.dx, pos.dy + personSize * 0.3),
          width: personSize * 1.2,
          height: personSize * 1.2,
        ),
        -math.pi,
        math.pi,
        true,
        personPaint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(pos.dx, pos.dy + personSize * 0.3),
          width: personSize * 1.2,
          height: personSize * 1.2,
        ),
        -math.pi,
        math.pi,
        true,
        personBorderPaint,
      );
    }

    // Connecting hearts (animated)
    if (progress > 0.3) {
      final heartOpacity = (progress - 0.3) * 1.5;
      _drawSmallHeart(
        canvas,
        Offset(center.dx, center.dy - size * 0.05),
        size * 0.08,
        color.withOpacity(heartOpacity.clamp(0.0, 1.0)),
      );
    }
  }

  void _drawSmallHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Left arc
    path.addArc(
      Rect.fromCircle(center: Offset(center.dx - size * 0.25, center.dy - size * 0.25), radius: size * 0.25),
      math.pi,
      math.pi,
    );

    // Right arc
    path.addArc(
      Rect.fromCircle(center: Offset(center.dx + size * 0.25, center.dy - size * 0.25), radius: size * 0.25),
      0,
      math.pi,
    );

    // Bottom point
    path.lineTo(center.dx, center.dy + size * 0.4);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawMilestones(Canvas canvas, Offset center, double size) {
    // Trophy base
    final trophyPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final trophyBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Trophy cup
    final cupPath = Path();
    cupPath.moveTo(center.dx - size * 0.3, center.dy - size * 0.2);
    cupPath.lineTo(center.dx - size * 0.35, center.dy + size * 0.15);
    cupPath.lineTo(center.dx + size * 0.35, center.dy + size * 0.15);
    cupPath.lineTo(center.dx + size * 0.3, center.dy - size * 0.2);
    cupPath.close();

    canvas.drawPath(cupPath, trophyPaint);
    canvas.drawPath(cupPath, trophyBorderPaint);

    // Trophy base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size * 0.25),
          width: size * 0.5,
          height: size * 0.1,
        ),
        const Radius.circular(4),
      ),
      trophyBorderPaint..style = PaintingStyle.fill,
    );

    // Star on top (animated)
    final starScale = progress;
    canvas.save();
    canvas.translate(center.dx, center.dy - size * 0.4);
    canvas.scale(starScale);

    _drawStar(
      canvas,
      Offset.zero,
      size * 0.15,
      color,
    );

    canvas.restore();

    // Sparkles around trophy
    if (progress > 0.5) {
      _drawSparkles(canvas, center, size * 0.5, progress);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const points = 5;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? size : size * 0.45;
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
    canvas.drawPath(path, borderPaint);
  }

  void _drawSparkles(Canvas canvas, Offset center, double radius, double progress) {
    final paint = Paint()
      ..color = color.withOpacity(0.5 * progress)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + progress * math.pi;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      _drawSparkle(canvas, Offset(x, y), 8, paint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

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

  void _drawRadiatingCircles(
      Canvas canvas, Offset center, double radius, double progress) {
    final paint = Paint()
      ..color = color.withOpacity(0.1 * (1 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius + radius * 0.2 * progress, paint);
    canvas.drawCircle(
      center,
      radius + radius * 0.4 * progress,
      paint..color = color.withOpacity(0.05 * (1 - progress)),
    );
  }

  @override
  bool shouldRepaint(_OnboardingIllustrationPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.type != type;
  }
}
