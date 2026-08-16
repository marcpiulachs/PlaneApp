import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/gauge.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Altímetro estilo aviación: dial en miles de pies con aguja larga
/// (centenas de pies) y aguja corta (miles), ventana Kollsman y lectura digital.
class Altimeter extends StatelessWidget {
  final double altitudeMeters;

  const Altimeter({
    super.key,
    required this.altitudeMeters,
  });

  @override
  Widget build(BuildContext context) {
    final altFt = altitudeMeters * 3.28084;
    // Aguja corta: miles de pies (0..10 000 ft por vuelta).
    final shortFraction = (altFt % 10000) / 10000;
    // Aguja larga: centenas de pies (0..1000 ft por vuelta).
    final longFraction = (altFt % 1000) / 1000;

    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _AltimeterDialPainter(),
              ),
              // Lectura digital (debajo de las agujas)
              Positioned(
                left: size * 0.36,
                top: size * 0.58,
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
                        altFt.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: size * 0.14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.instrumentMark,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        'ft',
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
                painter: _NeedleOnlyPainter(
                  fraction: longFraction,
                  color: AppTheme.instrumentMark,
                ),
              ),
              CustomPaint(
                size: Size(size, size),
                painter: _NeedleOnlyPainter(
                  fraction: shortFraction,
                  color: AppTheme.warning,
                  tipFactor: 0.62,
                  widthFactor: 0.05,
                ),
              ),
              // Ventana Kollsman (QNH)
              Positioned(
                bottom: size * 0.03,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.instrumentFace,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: AppTheme.instrumentMark.withValues(alpha: 0.5)),
                  ),
                  child: const Text(
                    'QNH 1013',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
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

class _AltimeterDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Arco de rango normal.
    paintDialArcs(canvas, center, radius * 0.86, [
      (0.0, 1.0, Colors.white.withValues(alpha: 0.7)),
    ], strokeWidth: 5);

    // Ticks y etiquetas de 0..10 (miles de pies).
    for (int i = 0; i <= 50; i++) {
      final isMajor = i % 5 == 0;
      final angle = dialAngle(i / 50);
      final start = polarPoint(center, radius - (isMajor ? 8 : 12), angle);
      final end = polarPoint(center, radius - (isMajor ? 20 : 17), angle);
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = AppTheme.instrumentMark
              .withValues(alpha: isMajor ? 1 : 0.5)
          ..strokeWidth = isMajor ? 2 : 1,
      );
    }
    paintDialLabels(canvas, center, radius, 0, 10, major: 10);
  }

  @override
  bool shouldRepaint(covariant _AltimeterDialPainter oldDelegate) => false;
}

class _NeedleOnlyPainter extends CustomPainter {
  final double fraction;
  final Color color;
  final double tipFactor;
  final double widthFactor;

  _NeedleOnlyPainter({
    required this.fraction,
    required this.color,
    this.tipFactor = 0.78,
    this.widthFactor = 0.035,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    paintNeedle(
      canvas,
      center,
      radius,
      fraction,
      color: color,
      tipFactor: tipFactor,
      widthFactor: widthFactor,
    );
    paintHub(canvas, center, radius);
  }

  @override
  bool shouldRepaint(covariant _NeedleOnlyPainter oldDelegate) =>
      oldDelegate.fraction != fraction || oldDelegate.color != color;
}