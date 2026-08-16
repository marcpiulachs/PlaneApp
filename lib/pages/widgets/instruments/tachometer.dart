import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/gauge.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

/// Tacómetro de doble aguja (motor 1 / motor 2), 0-100 %.
class Tachometer extends StatelessWidget {
  final double motor1;
  final double motor2;

  const Tachometer({
    super.key,
    required this.motor1,
    required this.motor2,
  });

  @override
  Widget build(BuildContext context) {
    final fraction1 = (motor1 / 100).clamp(0.0, 1.0);
    final fraction2 = (motor2 / 100).clamp(0.0, 1.0);
    final percent = ((motor1 + motor2) / 2).clamp(0.0, 100.0);

    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: const _TachDialPainter(),
              ),
              // Lectura digital (debajo de las agujas)
              Positioned(
                left: size * 0.38,
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
                        '${percent.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: size * 0.13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.instrumentMark,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        'M1 ${motor1.toStringAsFixed(0)} · M2 ${motor2.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: size * 0.05,
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
                painter: _DualNeedlePainter(
                  fraction1: fraction1,
                  fraction2: fraction2,
                ),
              ),
              Positioned(
                bottom: size * 0.03,
                child: const Text(
                  'RPM',
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

class _TachDialPainter extends CustomPainter {
  const _TachDialPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Arcos: zona verde hasta 70 %, amarilla hasta 85 %, roja por encima.
    paintDialArcs(canvas, center, radius * 0.86, [
      (0.0, 0.70, AppTheme.success),
      (0.70, 0.85, AppTheme.warning),
      (0.85, 1.0, AppTheme.error),
    ], strokeWidth: 5);

    paintDialTicks(canvas, center, radius, major: 10, minorPerMajor: 5);
    paintDialLabels(canvas, center, radius, 0, 100, major: 10);
  }

  @override
  bool shouldRepaint(covariant _TachDialPainter oldDelegate) => false;
}

class _DualNeedlePainter extends CustomPainter {
  final double fraction1;
  final double fraction2;

  _DualNeedlePainter({required this.fraction1, required this.fraction2});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    paintNeedle(
      canvas,
      center,
      radius,
      fraction1,
      color: AppTheme.success,
      widthFactor: 0.05,
      tipFactor: 0.68,
    );
    paintNeedle(
      canvas,
      center,
      radius,
      fraction2,
      color: AppTheme.warning,
      widthFactor: 0.05,
      tipFactor: 0.68,
    );
    paintHub(canvas, center, radius);
  }

  @override
  bool shouldRepaint(covariant _DualNeedlePainter oldDelegate) =>
      oldDelegate.fraction1 != fraction1 ||
      oldDelegate.fraction2 != fraction2;
}