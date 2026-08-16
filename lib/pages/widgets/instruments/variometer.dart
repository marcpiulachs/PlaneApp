import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Variometer (VSI): indica velocidad vertical en pies/minuto, derivada de la
/// altitud recibida.
class Variometer extends StatefulWidget {
  final double altitude; // metros

  const Variometer({
    super.key,
    required this.altitude,
  });

  @override
  State<Variometer> createState() => _VariometerState();
}

class _VariometerState extends State<Variometer> {
  static const double _maxFtMin = 2000;
  final Stopwatch _stopwatch = Stopwatch()..start();
  final List<(Duration, double)> _samples = [];
  double _vsiFtMin = 0;

  @override
  void didUpdateWidget(Variometer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.altitude != widget.altitude) {
      final now = _stopwatch.elapsed;
      _samples.add((now, widget.altitude));
      while (_samples.length > 2 &&
          now - _samples.first.$1 > const Duration(seconds: 5)) {
        _samples.removeAt(0);
      }
      if (_samples.length >= 2) {
        final newest = _samples.last;
        final oldest = _samples.first;
        final dt = (newest.$1 - oldest.$1).inMilliseconds / 1000.0;
        if (dt > 0.05) {
          final mps = (newest.$2 - oldest.$2) / dt;
          _vsiFtMin = (mps * 196.85).clamp(-_maxFtMin, _maxFtMin);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Lectura digital (debajo del dial para que no tape la aguja)
              Positioned(
                left: size * 0.40,
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
                        (_vsiFtMin >= 0 ? '+' : '') +
                            _vsiFtMin.round().toString(),
                        style: TextStyle(
                          fontSize: size * 0.13,
                          fontWeight: FontWeight.bold,
                          color: _vsiFtMin >= 0
                              ? AppTheme.success
                              : AppTheme.error,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        'ft/min',
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
                painter: _VsiDialPainter(vsi: _vsiFtMin),
              ),
              Positioned(
                bottom: size * 0.03,
                child: const Text(
                  'VERT SPEED',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.instrumentMark,
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

class _VsiDialPainter extends CustomPainter {
  final double vsi;

  _VsiDialPainter({required this.vsi});

  static const double _max = 2000;

  double _angleFor(double rate) {
    if (rate >= 0) {
      return -135 + (rate / _max) * 135; // 0..+2000: hacia arriba
    }
    return -135 + (rate / _max) * 45; // 0..-2000: hacia abajo
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Marcas del dial
    final markPaint = Paint()
      ..color = AppTheme.instrumentMark
      ..strokeWidth = 2;
    final minorPaint = Paint()
      ..color = AppTheme.instrumentMark.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    // Posiciones de referencia en ft/min (x100).
    final refs = [-20, -15, -10, -5, 0, 5, 10, 15, 20];
    for (final ref in refs) {
      final angle = _angleFor(ref * 100);
      final isMajor = ref % 10 == 0;
      final start = polarPoint(center, radius - (isMajor ? 8 : 12), angle);
      final end = polarPoint(center, radius - (isMajor ? 20 : 17), angle);
      canvas.drawLine(start, end, isMajor ? markPaint : minorPaint);

      if (isMajor) {
        _label(canvas, center, radius, angle, ref.toString());
      }
    }

    // Aguja
    final angle = _angleFor(vsi);
    final tip = polarPoint(center, radius * 0.78, angle);
    final rad = angle * pi / 180;
    final width = radius * 0.035;
    final left = Offset(center.dx + width * cos(rad),
        center.dy + width * sin(rad));
    final right = Offset(center.dx - width * cos(rad),
        center.dy - width * sin(rad));
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color = vsi >= 0 ? AppTheme.success : AppTheme.error);

    // Buje
    canvas.drawCircle(center, radius * 0.10, Paint()..color = AppTheme.instrumentFace);
    canvas.drawCircle(
        center,
        radius * 0.10,
        Paint()
          ..color = AppTheme.instrumentMark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
  }

  void _label(Canvas canvas, Offset center, double radius, double angle,
      String text) {
    final pos = polarPoint(center, radius - 32, angle);
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
  bool shouldRepaint(covariant _VsiDialPainter oldDelegate) =>
      oldDelegate.vsi != vsi;
}