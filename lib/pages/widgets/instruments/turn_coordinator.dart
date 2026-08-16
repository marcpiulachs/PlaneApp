import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

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
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final s = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Arco de referencia del giro (0.5 = virada estándar)
              Positioned(
                top: s * 0.06,
                child: SizedBox(
                  width: s,
                  height: s * 0.55,
                  child: CustomPaint(
                    painter: _ArcPainter(),
                  ),
                ),
              ),
              // Índice fijo superior
              Positioned(
                top: s * 0.06,
                child: SizedBox(
                  width: s,
                  height: s * 0.55,
                  child: CustomPaint(
                    painter: _IndexTrianglePainter(),
                  ),
                ),
              ),
              // Avión que se inclina según la tasa de giro
              Positioned(
                top: s * 0.06,
                child: SizedBox(
                  width: s,
                  height: s * 0.55,
                  child: Transform.rotate(
                    angle: -turnRate * (pi / 6),
                    child: const Center(
                      child: CustomPaint(
                        size: Size.square(80),
                        painter: MiniPlanePainter(),
                      ),
                    ),
                  ),
                ),
              ),
              // Bola de derrape
              Positioned(
                bottom: s * 0.20,
                child: SizedBox(
                  width: s * 0.62,
                  height: s * 0.10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: s * 0.62,
                        height: s * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(s * 0.035),
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      Positioned(
                        left: (slip + 1) / 2 * (s * 0.62 - s * 0.08),
                        child: Container(
                          width: s * 0.08,
                          height: s * 0.08,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Lecturas digitales
              Positioned(
                bottom: s * 0.04,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Readout(label: 'TURN', value: turnRate),
                    SizedBox(width: s * 0.10),
                    _Readout(label: 'SLIP', value: slip),
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

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = size.width * 0.62;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    // Arco superior de ~180°.
    canvas.drawArc(rect, pi, pi, false, paint);

    // Marcas L/R en los extremos
    final leftPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.28),
      Offset(size.width * 0.16, size.height * 0.42),
      leftPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.84, size.height * 0.28),
      Offset(size.width * 0.84, size.height * 0.42),
      leftPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) => false;
}

class _IndexTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 0);
    final path = Path()
      ..moveTo(center.dx, size.height * 0.08)
      ..lineTo(center.dx - 6, 0)
      ..lineTo(center.dx + 6, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _IndexTrianglePainter oldDelegate) => false;
}

class MiniPlanePainter extends CustomPainter {
  const MiniPlanePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = Colors.white;

    // Fuselaje (punto)
    canvas.drawCircle(center, 7, paint);

    // Alas
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: size.width * 0.55,
          height: 5,
        ),
        const Radius.circular(2),
      ),
      paint,
    );

    // Cola
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - 16),
          width: 5,
          height: 12,
        ),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MiniPlanePainter oldDelegate) => false;
}