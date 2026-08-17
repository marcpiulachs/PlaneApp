import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Turn Coordinator: tasa de giro (turnRate, -1..1) y derrape (slip, -1..1).
/// El avión se inclina hasta ±30° a deflexión completa (30°/s de giro).
class TurnCoordinator extends StatelessWidget {
  final double turnRate; // -1.0 (izquierda) a 1.0 (derecha)
  final double slip; // -1.0 (izquierda) a 1.0 (derecha)

  const TurnCoordinator({
    super.key,
    required this.turnRate,
    required this.slip,
  });

  @override
  Widget build(BuildContext context) {
    final rate = turnRate.clamp(-1.0, 1.0);
    final slipValue = slip.clamp(-1.0, 1.0);
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final s = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Dial: arco superior que llena la cara del instrumento
              SizedBox(
                width: s,
                height: s,
                child: CustomPaint(
                  painter: _TurnDialPainter(),
                ),
              ),
              // Avión que se inclina según la tasa de giro
              SizedBox(
                width: s,
                height: s,
                child: CustomPaint(
                  painter: _BankingPlanePainter(rate: rate),
                ),
              ),
              // Inclinómetro (bola de derrape) con graduaciones
              Positioned(
                bottom: s * 0.20,
                child: _Inclinometer(size: s, slip: slipValue),
              ),
              // Lecturas digitales
              Positioned(
                bottom: s * 0.04,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Readout(label: 'TURN', value: rate),
                    SizedBox(width: s * 0.10),
                    _Readout(label: 'SLIP', value: slipValue),
                  ],
                ),
              ),
              const GlassReflection(),
            ],
          );
        },
      ),
    );
  }
}

class _Readout extends StatelessWidget {
  final String label;
  final double value;

  const _Readout({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _TurnDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.47;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Arco superior (semicírculo).
    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Marcas de viraje cada 10°, destacando la estándar (±20° del centro).
    for (int deg = -80; deg <= 80; deg += 10) {
      final isStandard = deg % 20 == 0;
      final paint = Paint()
        ..color =
            isStandard ? AppTheme.warning : Colors.white.withValues(alpha: 0.5)
        ..strokeWidth = isStandard ? 3 : 1.5;
      final outer = polarPoint(center, radius - 2, deg.toDouble());
      final inner =
          polarPoint(center, radius - (isStandard ? 16 : 10), deg.toDouble());
      canvas.drawLine(outer, inner, paint);
    }

    // Índice fijo superior (doghouse).
    final idxPaint = Paint()..color = Colors.white;
    final idxPath = Path()
      ..moveTo(center.dx - 7, center.dy - radius + 2)
      ..lineTo(center.dx + 7, center.dy - radius + 2)
      ..lineTo(center.dx, center.dy - radius - 8)
      ..close();
    canvas.drawPath(idxPath, idxPaint);

    // Letras L / R en los extremos.
    _drawLabel(canvas, center, radius - 20, -90, 'L');
    _drawLabel(canvas, center, radius - 20, 90, 'R');
  }

  void _drawLabel(Canvas canvas, Offset center, double radius, double angleDeg,
      String text) {
    final pos = polarPoint(center, radius, angleDeg.toDouble());
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _TurnDialPainter oldDelegate) => false;
}

class _BankingPlanePainter extends CustomPainter {
  final double rate;

  _BankingPlanePainter({required this.rate});

  @override
  void paint(Canvas canvas, Size size) {
    // El avión se dibuja en el centro del instrumento.
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rate * (pi / 6));
    final paint = Paint()..color = Colors.white;

    // Alas (vista frontal).
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * 0.46,
          height: 6,
        ),
        const Radius.circular(3),
      ),
      paint,
    );

    // Empenaje vertical / fuselaje visto desde atrás.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(0, 18),
          width: 7,
          height: 18,
        ),
        const Radius.circular(3),
      ),
      paint,
    );

    // Buje central.
    canvas.drawCircle(Offset.zero, 4.5, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BankingPlanePainter oldDelegate) =>
      oldDelegate.rate != rate;
}

class _Inclinometer extends StatelessWidget {
  final double size;
  final double slip;

  const _Inclinometer({required this.size, required this.slip});

  @override
  Widget build(BuildContext context) {
    final w = size * 0.62;
    final ball = size * 0.08;
    final travel = w - ball;
    return SizedBox(
      width: w,
      height: size * 0.10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: w,
            height: size * 0.06,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(size * 0.03),
              border: Border.all(color: Colors.white24),
            ),
          ),
          CustomPaint(
            size: Size(w, size * 0.10),
            painter: _TubeTicksPainter(travel: travel),
          ),
          Positioned(
            left: (slip + 1) / 2 * travel,
            child: Container(
              width: ball,
              height: ball,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TubeTicksPainter extends CustomPainter {
  final double travel;

  _TubeTicksPainter({required this.travel});

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final centerX = size.width / 2;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 1.5;
    for (final t in [-0.25, 0.0, 0.25]) {
      final x = centerX + t * travel;
      final len = t == 0.0 ? 8.0 : 5.0;
      canvas.drawLine(Offset(x, cy - len / 2), Offset(x, cy + len / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TubeTicksPainter oldDelegate) =>
      oldDelegate.travel != travel;
}
