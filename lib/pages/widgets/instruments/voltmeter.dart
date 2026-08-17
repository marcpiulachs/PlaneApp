import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/gauge.dart';

class Voltmeter extends StatelessWidget {
  final double batteryVolts;

  const Voltmeter({
    super.key,
    required this.batteryVolts,
  });

  @override
  Widget build(BuildContext context) {
    return AnalogGauge(
      value: batteryVolts,
      min: 0,
      max: 5,
      unit: 'V',
      title: 'VOLTS',
      arcs: [
        (0.0, 0.47, AppTheme.error),
        (0.47, 0.87, AppTheme.success),
        (0.87, 1.0, AppTheme.error),
      ],
    );
  }
}