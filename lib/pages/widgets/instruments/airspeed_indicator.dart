import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Airspeed Indicator estilo aviación: dial con arcos de color
/// (blanco = flaps, verde = normal, amarillo = cautela, rojo = Vne).
class AirspeedIndicator extends StatelessWidget {
  final double speed;
  final double minSpeed;
  final double maxSpeed;
  final String unit;

  const AirspeedIndicator({
    super.key,
    required this.speed,
    this.minSpeed = 0,
    this.maxSpeed = 120,
    this.unit = 'km/h',
  });

  @override
  Widget build(BuildContext context) {
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          final angle = _angleFor(speed);
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _AirspeedDialPainter(
                  minSpeed: minSpeed,
                  maxSpeed: maxSpeed,
                ),
              ),
              // Lectura digital (debajo de la aguja para que no la tape)
              Positioned(
                left: size * 0.40,
                top: size * 0.56,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppTheme.instrumentMark.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        speed.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: size * 0.13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.instrumentMark,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: size * 0.06,
                          color: AppTheme.instrumentMark
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(size, size),
                painter: _AirspeedNeedlePainter(angleDegrees: angle),
              ),
              // Buje
              Container(
                width: size * 0.10,
                height: size * 0.10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.instrumentFace,
                  border: Border.all(color: AppTheme.instrumentMark, width: 1.5),
                ),
              ),
              const GlassReflection(),
            ],
          );
        },
      ),
    );
  }

  double _angleFor(double value) {
    final t = ((value - minSpeed) / (maxSpeed - minSpeed)).clamp(0.0, 1.0);
    return t * 270 - 135;
  }
}

class _AirspeedDialPainter extends CustomPainter {
  final double minSpeed;
  final double maxSpeed;

  _AirspeedDialPainter({required this.minSpeed, required this.maxSpeed});

  double _angleForFraction(double t) => t * 270 - 135;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ---- Arcos de color ----
    void drawArc(double from, double to, Color color, double strokeWidth) {
      final rect = Rect.fromCircle(
        center: center,
        radius: radius * 0.82,
      );
      final start = _angleForFraction(from) * pi / 180;
      final sweep = (_angleForFraction(to) - _angleForFraction(from)) * pi / 180;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, start, sweep, false, paint);
    }

    // Arco blanco (rango flaps): 0 - 40%
    drawArc(0.0, 0.40, Colors.white.withValues(alpha: 0.85), 7);
    // Arco verde (normal): 25 - 85%
    drawArc(0.25, 0.85, AppTheme.success, 7);
    // Arco amarillo (cautela): 85 - 95%
    drawArc(0.85, 0.95, AppTheme.warning, 7);
    // Línea roja (Vne): 95 - 100%
    drawArc(0.95, 1.0, AppTheme.error, 9);

    // ---- Ticks ----
    final tickPaint = Paint()
      ..color = AppTheme.instrumentMark
      ..strokeWidth = 2;
    final minorTickPaint = Paint()
      ..color = AppTheme.instrumentMark.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    for (int i = 0; i <= 50; i++) {
      final isMajor = i % 5 == 0;
      final angle = _angleForFraction(i / 50);
      final start = polarPoint(center, radius - (isMajor ? 8 : 12), angle);
      final end = polarPoint(center, radius - (isMajor ? 22 : 18), angle);
      canvas.drawLine(start, end, isMajor ? tickPaint : minorTickPaint);
      if (i % 5 == 0) {
        final value = minSpeed + (i / 50) * (maxSpeed - minSpeed);
        _drawLabel(canvas, center, radius, angle, value.toStringAsFixed(0));
      }
    }
  }

  void _drawLabel(
      Canvas canvas, Offset center, double radius, double angle, String text) {
    final pos = polarPoint(center, radius - 34, angle);
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppTheme.instrumentMark,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    final rad = angle * pi / 180;
    canvas.rotate(rad + pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AirspeedNeedlePainter extends CustomPainter {
  final double angleDegrees;

  _AirspeedNeedlePainter({required this.angleDegrees});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angleRad = angleDegrees * pi / 180;

    final tip = polarPoint(center, radius * 0.78, angleDegrees);
    final tail = polarPoint(center, -radius * 0.22, angleDegrees);
    final width = radius * 0.035;

    final left = Offset(
      center.dx + width * cos(angleRad),
      center.dy + width * sin(angleRad),
    );
    final right = Offset(
      center.dx - width * cos(angleRad),
      center.dy - width * sin(angleRad),
    );

    // Cuerpo blanco
    final body = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(
        body, Paint()..color = AppTheme.instrumentMark);

    // Contrapeso rojo
    final tailLeft = polarPoint(center, radius * 0.10, angleDegrees + 90);
    final tailRight = polarPoint(center, radius * 0.10, angleDegrees - 90);
    final tailPath = Path()
      ..moveTo(tail.dx, tail.dy)
      ..lineTo(tailLeft.dx, tailLeft.dy)
      ..lineTo(tailRight.dx, tailRight.dy)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = AppTheme.error);
  }

  @override
  bool shouldRepaint(covariant _AirspeedNeedlePainter oldDelegate) =>
      oldDelegate.angleDegrees != angleDegrees;
}