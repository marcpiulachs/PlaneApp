import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/instruments/gauge.dart';

/// G-meter: fuerza g vertical estimada a partir de la aceleración Z.
class GMeter extends StatelessWidget {
  final double accelZ;

  const GMeter({
    super.key,
    required this.accelZ,
  });

  @override
  Widget build(BuildContext context) {
    // rango bruto del acelerómetro ≈ -1000..1000 → ≈ ±2 g (estimado)
    final g = (accelZ / 500).clamp(-2.0, 2.0);
    return AnalogGauge(
      value: g,
      min: -2,
      max: 2,
      unit: 'G',
      title: 'G-FORCE',
      needleColor: AppTheme.warning,
      arcs: [
        (0.40, 0.60, AppTheme.success),
        (0.60, 1.0, AppTheme.warning),
      ],
    );
  }
}