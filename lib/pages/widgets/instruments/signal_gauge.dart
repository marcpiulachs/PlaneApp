import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/gauge.dart';

class SignalGauge extends StatelessWidget {
  final double signal;

  const SignalGauge({
    super.key,
    required this.signal,
  });

  @override
  Widget build(BuildContext context) {
    return AnalogGauge(
      value: signal,
      min: 0,
      max: 100,
      unit: '%',
      title: 'SIGNAL',
      arcs: [
        (0.0, 0.30, AppTheme.error),
        (0.30, 0.60, AppTheme.warning),
        (0.60, 1.0, AppTheme.success),
      ],
    );
  }
}