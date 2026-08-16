import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/instrument_bezel.dart';

class FlightClock extends StatefulWidget {
  const FlightClock({super.key});

  @override
  State<FlightClock> createState() => _FlightClockState();
}

class _FlightClockState extends State<FlightClock> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InstrumentBezel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          final second = _now.second + _now.millisecond / 1000.0;
          final minute = _now.minute + second / 60.0;
          final hour = (_now.hour % 12) + minute / 60.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Lectura digital (debajo de las manecillas)
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
                  child: Text(
                    '${_two(_now.hour)}:${_two(_now.minute)}:${_two(_now.second)}',
                    style: TextStyle(
                      fontSize: size * 0.12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.instrumentMark,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                size: Size(size, size),
                painter: _ClockDialPainter(
                  second: second,
                  minute: minute,
                  hour: hour,
                ),
              ),
              const GlassReflection(),
            ],
          );
        },
      ),
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}

class _ClockDialPainter extends CustomPainter {
  final double second;
  final double minute;
  final double hour;

  _ClockDialPainter({
    required this.second,
    required this.minute,
    required this.hour,
  });

  double _hand(double value, double perRevolution) =>
      value / perRevolution * 360 - 90;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Ticks: 12 mayores, 60 menores
    for (int i = 0; i < 60; i++) {
      final isMajor = i % 5 == 0;
      final angle = i * 6.0;
      final start = polarPoint(center, radius - (isMajor ? 6 : 10), angle);
      final end = polarPoint(center, radius - (isMajor ? 18 : 14), angle);
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = AppTheme.instrumentMark
              .withValues(alpha: isMajor ? 1 : 0.5)
          ..strokeWidth = isMajor ? 2.5 : 1,
      );
    }

    // Numeración
    for (int i = 1; i <= 12; i++) {
      final angle = i * 30.0;
      final pos = polarPoint(center, radius - 28, angle);
      final tp = TextPainter(
        text: TextSpan(
          text: '$i',
          style: const TextStyle(
            color: AppTheme.instrumentMark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }

    // Manecillas
    _drawHand(canvas, center, radius, _hand(hour, 12), radius * 0.45, 4,
        AppTheme.instrumentMark);
    _drawHand(canvas, center, radius, _hand(minute, 60), radius * 0.65, 2.5,
        AppTheme.instrumentMark);
    _drawHand(canvas, center, radius, _hand(second, 60), radius * 0.75, 1.5,
        AppTheme.warning);

    // Buje
    canvas.drawCircle(center, radius * 0.05, Paint()..color = AppTheme.warning);
  }

  void _drawHand(Canvas canvas, Offset center, double radius, double angle,
      double length, double width, Color color) {
    final rad = angle * pi / 180;
    final tip = Offset(
      center.dx + length * cos(rad),
      center.dy + length * sin(rad),
    );
    final tail = Offset(
      center.dx - radius * 0.15 * cos(rad),
      center.dy - radius * 0.15 * sin(rad),
    );
    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ClockDialPainter oldDelegate) =>
      oldDelegate.second != second ||
      oldDelegate.minute != minute ||
      oldDelegate.hour != hour;
}