import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Attitude Direction Indicator (ADI): horizonte artificial con escala de
/// banqueo, pitch ladder y silueta de avión fija, como en un cockpit real.
class AttitudeIndicator extends StatelessWidget {
  final double roll;
  final double pitch;

  const AttitudeIndicator({
    super.key,
    required this.roll,
    required this.pitch,
  });

  @override
  Widget build(BuildContext context) {
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Parte rotatoria: cielo, tierra, horizonte y pitch ladder.
              CustomPaint(
                painter: _HorizonPainter(roll: roll, pitch: pitch),
              ),
              // Parte fija: escala de banqueo, índice y silueta del avión.
              CustomPaint(
                painter: _FixedPlanePainter(),
              ),
              const GlassReflection(),
            ],
          );
        },
      ),
    );
  }
}

class _HorizonPainter extends CustomPainter {
  final double roll;
  final double pitch;

  _HorizonPainter({required this.roll, required this.pitch});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final horizonY = center.dy + pitch * (size.height / 90);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(roll * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    // Cielo
    final skyRect = Rect.fromLTRB(0, 0, size.width, horizonY);
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.sky, AppTheme.skyHorizon],
        ).createShader(skyRect),
    );
    // Tierra
    final groundRect =
        Rect.fromLTRB(0, horizonY, size.width, size.height);
    canvas.drawRect(
      groundRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.groundHorizon, AppTheme.ground],
        ).createShader(groundRect),
    );
    // Línea del horizonte
    canvas.drawLine(
      Offset(0, horizonY),
      Offset(size.width, horizonY),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2,
    );

    // Pitch ladder (cada 10°)
    final pitchScale = size.height / 90;
    for (int deg = 10; deg <= 60; deg += 10) {
      for (final sign in [1, -1]) {
        final d = deg * sign;
        final y = horizonY - d * pitchScale;
        final lineWidth = size.width * (0.16 + d.abs() * 0.003);
        canvas.drawLine(
          Offset(center.dx - lineWidth, y),
          Offset(center.dx + lineWidth, y),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2,
        );
        // Etiqueta de grados a la izquierda
        if (deg % 10 == 0) {
          _drawLadderLabel(
              canvas, center.dx - lineWidth - 22, y, '${deg * sign}');
        }
      }
    }

    canvas.restore();
  }

  void _drawLadderLabel(Canvas canvas, double x, double y, String text) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _HorizonPainter oldDelegate) =>
      oldDelegate.roll != roll || oldDelegate.pitch != pitch;
}

class _FixedPlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Escala de banqueo en la parte superior (no rota con el horizonte).
    _drawBankScale(canvas, center, size.width / 2);
    // Índice fijo superior.
    _drawTopIndex(canvas, center, size.width / 2);

    // Silueta del avión (fuselaje + alas).
    final paint = Paint()..color = Colors.white;
    final w = size.width;

    // Fuselaje
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: w * 0.10, height: w * 0.34),
        const Radius.circular(4),
      ),
      paint,
    );
    // Alas
    final wingPaint = Paint()..color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: w * 0.56,
          height: w * 0.07,
        ),
        const Radius.circular(3),
      ),
      wingPaint,
    );
    // Empenaje
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - w * 0.22),
          width: w * 0.20,
          height: w * 0.08,
        ),
        const Radius.circular(3),
      ),
      paint,
    );
  }

  void _drawBankScale(Canvas canvas, Offset center, double radius) {
    final markPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final trianglePaint = Paint()..color = Colors.white;

    for (final side in [1, -1]) {
      for (final deg in [0, 10, 20, 30, 45, 60, 90]) {
        if (deg == 0 && side == -1) continue;
        final d = deg * side;
        final angleDeg = d.toDouble();
        // En la parte superior: -90..90 desde la vertical.
        final inner = polarPoint(center, radius * 0.86, angleDeg);
        final outer = polarPoint(center, radius * 0.98, angleDeg);

        if (deg == 30 || deg == 60) {
          // Triángulo
          final tip = outer;
          final base = polarPoint(center, radius * 0.86, angleDeg);
          final perp = polarPoint(center, radius * 0.95, angleDeg + 90);
          final path = Path()
            ..moveTo(tip.dx, tip.dy)
            ..lineTo(base.dx, base.dy)
            ..lineTo(perp.dx, perp.dy)
            ..close();
          canvas.drawPath(path, trianglePaint);
        } else {
          final lineEnd = polarPoint(
              center,
              radius * (deg == 0 ? 0.90 : deg == 45 ? 0.94 : 0.98),
              angleDeg);
          canvas.drawLine(inner, lineEnd, markPaint);
        }
      }
    }
  }

  void _drawTopIndex(Canvas canvas, Offset center, double radius) {
    final tip = polarPoint(center, radius * 0.95, 0);
    final left = polarPoint(center, radius * 0.84, 10);
    final right = polarPoint(center, radius * 0.84, -10);
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(covariant _FixedPlanePainter oldDelegate) => false;
}