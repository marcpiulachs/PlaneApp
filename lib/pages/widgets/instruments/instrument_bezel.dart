import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

/// Cara común de los instrumentos de vuelo: bisel oscuro, fondo mate y
/// reflejo de vidrio. Proporciona la "lubber line" (índice fijo superior).
class InstrumentBezel extends StatelessWidget {
  final Widget child;
  final bool showIndex;
  final Color faceColor;

  const InstrumentBezel({
    super.key,
    required this.child,
    this.showIndex = false,
    this.faceColor = AppTheme.instrumentFace,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF5A5A62),
                AppTheme.instrumentBezel,
                Color(0xFF1C1C20),
              ],
            ),
            border: Border.all(color: Colors.black45, width: 1.5),
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: faceColor,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: ClipOval(child: child),
          ),
        ),
      ),
    );
  }
}

/// Reflejo de vidrio sutil sobre la cara del instrumento.
class GlassReflection extends StatelessWidget {
  const GlassReflection({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _GlassReflectionPainter()),
    );
  }
}

class _GlassReflectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.4, -0.7),
        radius: 0.9,
        colors: [
          Color(0x33FFFFFF),
          Color(0x0DFFFFFF),
          Color(0x00000000),
        ],
        stops: [0.0, 0.35, 0.8],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dibuja una marca de índice fija en la parte superior (avión real).
class LubberLine extends StatelessWidget {
  const LubberLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -2,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 26,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.instrumentMark,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Helper: posición en un círculo (0° = arriba, sentido horario).
Offset polarPoint(Offset center, double radius, double angleDeg) {
  final rad = angleDeg * math.pi / 180;
  return Offset(
    center.dx + radius * math.sin(rad),
    center.dy - radius * math.cos(rad),
  );
}