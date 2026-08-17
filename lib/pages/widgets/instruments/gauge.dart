import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Ángulo (grados, 0° = arriba) para una fracción del rango sobre un arco de 270°.
double dialAngle(double fraction) => fraction * 270 - 135;

/// Pinta arcos de color sobre el dial (fracciones 0..1).
void paintDialArcs(
  Canvas canvas,
  Offset center,
  double radius,
  List<(double, double, Color)> arcs, {
  double strokeWidth = 7,
}) {
  final rect = Rect.fromCircle(center: center, radius: radius);
  for (final (from, to, color) in arcs) {
    final start = dialAngle(from) * pi / 180;
    final sweep = (dialAngle(to) - dialAngle(from)) * pi / 180;
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }
}

/// Pinta ticks mayores y menores sobre el dial.
void paintDialTicks(
  Canvas canvas,
  Offset center,
  double radius, {
  int major = 10,
  int minorPerMajor = 5,
  Color? color,
}) {
  final mark = color ?? AppTheme.instrumentMark;
  final majorPaint = Paint()
    ..color = mark
    ..strokeWidth = 2;
  final minorPaint = Paint()
    ..color = mark.withValues(alpha: 0.5)
    ..strokeWidth = 1;
  final segments = major * minorPerMajor;
  for (int i = 0; i <= segments; i++) {
    final isMajor = i % minorPerMajor == 0;
    final angle = dialAngle(i / segments);
    final start = polarPoint(center, radius - (isMajor ? 8 : 12), angle);
    final end = polarPoint(center, radius - (isMajor ? 22 : 18), angle);
    canvas.drawLine(start, end, isMajor ? majorPaint : minorPaint);
  }
}

/// Pinta etiquetas de valor en los ticks mayores.
void paintDialLabels(
  Canvas canvas,
  Offset center,
  double radius,
  double min,
  double max, {
  int major = 10,
  Color? color,
  int decimals = 0,
}) {
  for (int i = 0; i <= major; i++) {
    final frac = i / major;
    final value = min + frac * (max - min);
    final angle = dialAngle(frac);
    final pos = polarPoint(center, radius - 36, angle);
    final tp = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(decimals),
        style: TextStyle(
          color: color ?? AppTheme.instrumentMark,
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
}

/// Pinta una aguja desde el centro con buje.
void paintNeedle(
  Canvas canvas,
  Offset center,
  double radius,
  double fraction, {
  Color color = AppTheme.instrumentMark,
  double widthFactor = 0.035,
  double tipFactor = 0.78,
}) {
  final angle = dialAngle(fraction.clamp(0.0, 1.0));
  final angleRad = angle * pi / 180;
  final tip = polarPoint(center, radius * tipFactor, angle);
  final width = radius * widthFactor;
  final left = Offset(
    center.dx + width * cos(angleRad),
    center.dy + width * sin(angleRad),
  );
  final right = Offset(
    center.dx - width * cos(angleRad),
    center.dy - width * sin(angleRad),
  );
  final body = Path()
    ..moveTo(tip.dx, tip.dy)
    ..lineTo(left.dx, left.dy)
    ..lineTo(right.dx, right.dy)
    ..close();
  canvas.drawPath(body, Paint()..color = color);
}

void paintHub(Canvas canvas, Offset center, double radius,
    {double fraction = 0.10}) {
  canvas.drawCircle(
    center,
    radius * fraction,
    Paint()..color = AppTheme.instrumentFace,
  );
  canvas.drawCircle(
    center,
    radius * fraction,
    Paint()
      ..color = AppTheme.instrumentMark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );
}

/// Widget base para una gauge circular analógica con lecturas digitales.
class AnalogGauge extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String unit;
  final String title;
  final Color needleColor;
  final List<(double, double, Color)> arcs;
  final int majorTicks;
  final int minorPerMajor;

  const AnalogGauge({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.unit = '',
    this.title = '',
    this.needleColor = AppTheme.instrumentMark,
    this.arcs = const [],
    this.majorTicks = 10,
    this.minorPerMajor = 5,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = ((value - min) / (max - min)).clamp(0.0, 1.0);
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _AnalogGaugePainter(
                  min: min,
                  max: max,
                  arcs: arcs,
                  majorTicks: majorTicks,
                  minorPerMajor: minorPerMajor,
                ),
              ),
              // Lectura digital centrada en la parte inferior
              Positioned(
                left: 0,
                right: 0,
                top: size * 0.62,
                child: Center(
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
                          value.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: size * 0.13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.instrumentMark,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        if (unit.isNotEmpty)
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
              ),
              CustomPaint(
                size: Size(size, size),
                painter: _NeedlePainter(
                  fraction: fraction,
                  color: needleColor,
                ),
              ),
              if (title.isNotEmpty)
                Positioned(
                  bottom: size * 0.03,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: size * 0.08,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.instrumentMark.withValues(alpha: 0.6),
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

class _AnalogGaugePainter extends CustomPainter {
  final double min;
  final double max;
  final List<(double, double, Color)> arcs;
  final int majorTicks;
  final int minorPerMajor;

  _AnalogGaugePainter({
    required this.min,
    required this.max,
    required this.arcs,
    required this.majorTicks,
    required this.minorPerMajor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    if (arcs.isNotEmpty) {
      paintDialArcs(canvas, center, radius * 0.84, arcs);
    }
    paintDialTicks(canvas, center, radius,
        major: majorTicks, minorPerMajor: minorPerMajor);
    paintDialLabels(canvas, center, radius, min, max, major: majorTicks);
  }

  @override
  bool shouldRepaint(covariant _AnalogGaugePainter oldDelegate) =>
      oldDelegate.min != min ||
      oldDelegate.max != max ||
      oldDelegate.arcs != arcs;
}

class _NeedlePainter extends CustomPainter {
  final double fraction;
  final Color color;

  _NeedlePainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    paintNeedle(canvas, center, radius, fraction, color: color);
    paintHub(canvas, center, radius);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) =>
      oldDelegate.fraction != fraction || oldDelegate.color != color;
}