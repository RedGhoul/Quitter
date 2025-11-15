import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom error state illustration using CustomPainter.
///
/// Creates a scalable, themeable illustration showing a warning symbol
/// with alert indicators, perfect for error states and failures.
///
/// Usage:
/// ```dart
/// ErrorStateIllustration(
///   size: 200,
///   color: Theme.of(context).colorScheme.error,
/// )
/// ```
class ErrorStateIllustration extends StatefulWidget {
  final double size;
  final Color? color;
  final bool animated;
  final ErrorIllustrationType type;

  const ErrorStateIllustration({
    super.key,
    this.size = 200,
    this.color,
    this.animated = true,
    this.type = ErrorIllustrationType.warning,
  });

  @override
  State<ErrorStateIllustration> createState() =>
      _ErrorStateIllustrationState();
}

enum ErrorIllustrationType {
  warning, // Triangle with exclamation
  error, // X symbol with circle
  offline, // Cloud with slash
}

class _ErrorStateIllustrationState extends State<ErrorStateIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
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
    final color = widget.color ?? Theme.of(context).colorScheme.error;

    if (!widget.animated) {
      return CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _ErrorStateIllustrationPainter(
          color: color,
          scale: 1.0,
          type: widget.type,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _ErrorStateIllustrationPainter(
            color: color,
            scale: _pulseAnimation.value,
            type: widget.type,
          ),
        );
      },
    );
  }
}

class _ErrorStateIllustrationPainter extends CustomPainter {
  final Color color;
  final double scale;
  final ErrorIllustrationType type;

  _ErrorStateIllustrationPainter({
    required this.color,
    required this.scale,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx, -center.dy);

    switch (type) {
      case ErrorIllustrationType.warning:
        _drawWarning(canvas, center, size.width * 0.4);
        break;
      case ErrorIllustrationType.error:
        _drawError(canvas, center, size.width * 0.4);
        break;
      case ErrorIllustrationType.offline:
        _drawOffline(canvas, center, size.width * 0.4);
        break;
    }

    canvas.restore();

    // Alert circles around the icon
    _drawAlertCircles(canvas, center, size.width * 0.45);
  }

  void _drawWarning(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Triangle
    final path = Path();
    final height = size * math.sqrt(3) / 2;

    path.moveTo(center.dx, center.dy - height * 0.6); // Top
    path.lineTo(center.dx - size * 0.5, center.dy + height * 0.4); // Bottom left
    path.lineTo(center.dx + size * 0.5, center.dy + height * 0.4); // Bottom right
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Exclamation mark
    final exclamationPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // Exclamation line
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - size * 0.1),
          width: 4,
          height: size * 0.35,
        ),
        const Radius.circular(2),
      ),
      exclamationPaint,
    );

    // Exclamation dot
    canvas.drawCircle(
      Offset(center.dx, center.dy + size * 0.25),
      3,
      exclamationPaint,
    );
  }

  void _drawError(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Circle
    canvas.drawCircle(center, size, paint);
    canvas.drawCircle(center, size, borderPaint);

    // X mark
    final xPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final xSize = size * 0.5;
    canvas.drawLine(
      Offset(center.dx - xSize, center.dy - xSize),
      Offset(center.dx + xSize, center.dy + xSize),
      xPaint,
    );
    canvas.drawLine(
      Offset(center.dx + xSize, center.dy - xSize),
      Offset(center.dx - xSize, center.dy + xSize),
      xPaint,
    );
  }

  void _drawOffline(Canvas canvas, Offset center, double size) {
    // Cloud shape
    final cloudPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final cloudBorderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    final cloudCenter = Offset(center.dx, center.dy - size * 0.1);

    // Main cloud body
    path.addOval(Rect.fromCenter(
      center: cloudCenter,
      width: size * 1.2,
      height: size * 0.8,
    ));

    // Cloud bumps
    path.addOval(Rect.fromCenter(
      center: Offset(cloudCenter.dx - size * 0.3, cloudCenter.dy - size * 0.2),
      width: size * 0.7,
      height: size * 0.7,
    ));

    path.addOval(Rect.fromCenter(
      center: Offset(cloudCenter.dx + size * 0.3, cloudCenter.dy - size * 0.15),
      width: size * 0.6,
      height: size * 0.6,
    ));

    canvas.drawPath(path, cloudPaint);
    canvas.drawPath(path, cloudBorderPaint);

    // Diagonal slash
    final slashPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - size * 0.6, center.dy - size * 0.6),
      Offset(center.dx + size * 0.6, center.dy + size * 0.4),
      slashPaint,
    );
  }

  void _drawAlertCircles(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Outer circle
    canvas.drawCircle(center, radius, paint);

    // Middle circle
    canvas.drawCircle(center, radius * 1.15, paint);

    // Dots around
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final dotRadius = radius * 1.3;
      final dotX = center.dx + math.cos(angle) * dotRadius;
      final dotY = center.dy + math.sin(angle) * dotRadius;

      canvas.drawCircle(
        Offset(dotX, dotY),
        2,
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ErrorStateIllustrationPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.color != color ||
        oldDelegate.type != type;
  }
}

/// Simplified error illustration for inline usage
class SimpleErrorIllustration extends StatelessWidget {
  final double size;
  final Color? color;

  const SimpleErrorIllustration({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.error;

    return CustomPaint(
      size: Size(size, size),
      painter: _SimpleErrorPainter(color: color),
    );
  }
}

class _SimpleErrorPainter extends CustomPainter {
  final Color color;

  _SimpleErrorPainter({required this.color});

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

    // Exclamation mark
    final exclamationPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Line
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius * 0.15),
          width: 4,
          height: radius * 0.9,
        ),
        const Radius.circular(2),
      ),
      exclamationPaint,
    );

    // Dot
    canvas.drawCircle(
      Offset(center.dx, center.dy + radius * 0.55),
      3,
      exclamationPaint,
    );
  }

  @override
  bool shouldRepaint(_SimpleErrorPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
