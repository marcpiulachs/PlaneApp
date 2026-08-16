import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

class CompassWidget extends StatelessWidget {
  final double degrees;
  final Color textColor;
  final Color barsColor;
  final bool showDegrees;
  final Widget? child;

  const CompassWidget({
    super.key,
    required this.degrees,
    this.textColor = AppTheme.instrumentMark,
    this.barsColor = AppTheme.instrumentMark,
    this.showDegrees = true,
    this.child,
  });

  double get _heading {
    // Normaliza a 0..360.
    return (degrees % 360 + 360) % 360;
  }

  String getCardinalDirection(double deg) {
    final d = (deg % 360 + 360) % 360;
    if (d >= 337.5 || d < 22.5) return "N";
    if (d < 67.5) return "NE";
    if (d < 112.5) return "E";
    if (d < 157.5) return "SE";
    if (d < 202.5) return "S";
    if (d < 247.5) return "SW";
    if (d < 292.5) return "W";
    return "NW";
  }

  @override
  Widget build(BuildContext context) {
    final heading = _heading;
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: (heading - 90) * pi / 180,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: CompassCardPainter(
                    heading: heading,
                    textColor: textColor,
                    barsColor: barsColor,
                    showDegrees: showDegrees,
                  ),
                ),
              ),
              if (child != null) child!,
              // Lubber line fija (rumbo actual)
              Positioned(
                top: 4,
                child: Container(
                  width: 22,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Caja de heading digital
              Positioned(
                bottom: size * 0.08,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        heading.toString().padLeft(3, '0'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        getCardinalDirection(heading),
                        style: const TextStyle(
                          color: AppTheme.warning,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

class CompassCardPainter extends CustomPainter {
  final double heading;
  final Color textColor;
  final Color barsColor;
  final bool showDegrees;

  CompassCardPainter({
    required this.heading,
    required this.textColor,
    required this.barsColor,
    required this.showDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Marcas cada 5° con jerarquía de tamaños.
    for (int i = 0; i < 360; i += 5) {
      final isCardinal = i % 90 == 0;
      final is30 = i % 30 == 0;
      final is10 = i % 10 == 0;
      final length = isCardinal
          ? 24.0
          : is30
              ? 18.0
              : is10
                  ? 14.0
                  : 9.0;
      final paint = Paint()
        ..color = (isCardinal ? AppTheme.error : barsColor)
            .withValues(alpha: is10 ? 1.0 : 0.6)
        ..strokeWidth = isCardinal ? 3 : 2;
      final start = polarPoint(center, radius - length, i.toDouble());
      final end = polarPoint(center, radius, i.toDouble());
      canvas.drawLine(start, end, paint);
    }

    // Etiquetas cada 30°.
    for (int i = 0; i < 360; i += 30) {
      final isCardinal = i % 90 == 0;
      final label = isCardinal
          ? getLabel(i)
          : (showDegrees ? i.toString() : null);
      if (label == null) continue;
      final pos = polarPoint(center, radius - 36, i.toDouble());
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: isCardinal ? AppTheme.error : textColor,
            fontSize: isCardinal ? 20 : 12,
            fontWeight: isCardinal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate((i - 90) * pi / 180);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  String getLabel(int i) {
    switch (i) {
      case 0:
        return "N";
      case 90:
        return "E";
      case 180:
        return "S";
      case 270:
        return "W";
      default:
        return i.toString();
    }
  }

  @override
  bool shouldRepaint(covariant CompassCardPainter oldDelegate) =>
      oldDelegate.heading != heading ||
      oldDelegate.textColor != textColor ||
      oldDelegate.barsColor != barsColor;
}