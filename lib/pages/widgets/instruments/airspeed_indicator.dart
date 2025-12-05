import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

/// Un instrumento de estilo aviación para mostrar la velocidad (Airspeed Indicator).
class AirspeedIndicator extends StatelessWidget {
  final double speed; // Velocidad actual
  final double minSpeed;
  final double maxSpeed;
  final String unit;
  final double size;

  const AirspeedIndicator({
    super.key,
    required this.speed,
    this.minSpeed = 0,
    this.maxSpeed = 120,
    this.unit = 'km/h',
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveSize = constraints.maxHeight;
        // El dial usa: angle = (i / 10) * 270 - 135
        // Para la aguja:
        final double angle =
            ((speed - minSpeed) / (maxSpeed - minSpeed)) * 270 - 135;
        return SizedBox(
          width: effectiveSize,
          height: effectiveSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fondo
              Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  shape: BoxShape.circle,
                ),
              ),
              // Esfera
              CustomPaint(
                size: Size(effectiveSize, effectiveSize),
                painter: _AirspeedDialPainter(minSpeed, maxSpeed),
              ),
              // Aguja
              CustomPaint(
                size: Size(effectiveSize, effectiveSize),
                painter: _AirspeedNeedlePainter(
                  angleDegrees: angle,
                  color: AppTheme.primary,
                ),
              ),
              // Centro
              Container(
                width: effectiveSize * 0.12,
                height: effectiveSize * 0.12,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDarker,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
              ),
              // Texto de velocidad dentro del círculo, alineado a la izquierda
              Positioned(
                left: effectiveSize * 0.4,
                top: effectiveSize * 0.5 - 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      speed.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AirspeedDialPainter extends CustomPainter {
  final double minSpeed;
  final double maxSpeed;
  _AirspeedDialPainter(this.minSpeed, this.maxSpeed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final tickPaint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2;
    final labelStyle = const TextStyle(
      color: AppTheme.warning,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    // Dibujar ticks mayores y etiquetas
    for (int i = 0; i <= 10; i++) {
      final value = minSpeed + (i / 10) * (maxSpeed - minSpeed);
      final angle = (i / 10) * 270 - 135;
      final rad = angle * pi / 180;
      final tickStart = Offset(
        center.dx + (radius - 10) * cos(rad),
        center.dy + (radius - 10) * sin(rad),
      );
      final tickEnd = Offset(
        center.dx + (radius - 25) * cos(rad),
        center.dy + (radius - 25) * sin(rad),
      );
      canvas.drawLine(tickStart, tickEnd, tickPaint);
      // Etiquetas
      final labelX = center.dx + (radius - 38) * cos(rad);
      final labelY = center.dy + (radius - 38) * sin(rad);
      final textSpan = TextSpan(
        text: value.toStringAsFixed(0),
        style: labelStyle,
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      canvas.save();
      canvas.translate(labelX, labelY);
      canvas.rotate(rad + pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Dibujar ticks menores entre los mayores
    final minorTickPaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.6)
      ..strokeWidth = 1;
    for (int i = 0; i < 50; i++) {
      if (i % 5 == 0) continue; // Saltar los mayores
      final angle = (i / 50) * 270 - 135;
      final rad = angle * pi / 180;
      final tickStart = Offset(
        center.dx + (radius - 12) * cos(rad),
        center.dy + (radius - 12) * sin(rad),
      );
      final tickEnd = Offset(
        center.dx + (radius - 20) * cos(rad),
        center.dy + (radius - 20) * sin(rad),
      );
      canvas.drawLine(tickStart, tickEnd, minorTickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _AirspeedNeedlePainter extends CustomPainter {
  final double angleDegrees;
  final Color color;
  _AirspeedNeedlePainter({required this.angleDegrees, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angleRad = angleDegrees * pi / 180; // 0° arriba
    final needleLength = radius * 0.78;
    final needleWidth = radius * 0.04;

    // Triángulo de la aguja
    final tip = Offset(
      center.dx + needleLength * cos(angleRad),
      center.dy + needleLength * sin(angleRad),
    );
    final left = Offset(
      center.dx + needleWidth * cos(angleRad + pi / 2),
      center.dy + needleWidth * sin(angleRad + pi / 2),
    );
    final right = Offset(
      center.dx + needleWidth * cos(angleRad - pi / 2),
      center.dy + needleWidth * sin(angleRad - pi / 2),
    );

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
