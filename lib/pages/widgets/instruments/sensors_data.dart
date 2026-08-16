import 'package:flutter/material.dart';
import 'package:paperwings/models/telemetry.dart';
import 'package:paperwings/config/app_theme.dart';

class SensorsData extends StatelessWidget {
  final Telemetry telemetry;

  const SensorsData({
    super.key,
    required this.telemetry,
  });

  @override
  Widget build(BuildContext context) {
    final t = telemetry;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.instrumentFace,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.instrumentBezel),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TELEMETRY',
              style: TextStyle(
                color: AppTheme.warning,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _values(t, left: true)),
                const SizedBox(width: 20),
                Expanded(child: _values(t, left: false)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _values(Telemetry t, {required bool left}) {
    final rows = left
        ? [
            ('PITCH', '${t.pitch.round()}°'),
            ('ROLL', '${t.roll.round()}°'),
            ('YAW', '${t.yaw.round()}°'),
            ('GYRO', '${t.gyroZ.toStringAsPrecision(2)}°/s'),
            ('ALT', '${t.altitude.toStringAsFixed(0)} m'),
            ('PRESS', '${t.barometer.toStringAsFixed(1)} hPa'),
          ]
        : [
            ('ACC X', '${t.accelX.toStringAsPrecision(2)}'),
            ('ACC Y', '${t.accelY.toStringAsPrecision(2)}'),
            ('ACC Z', '${t.accelZ.toStringAsPrecision(2)}'),
            ('MAG X', '${t.magX.round()}'),
            ('MAG Y', '${t.magY.round()}'),
            ('MAG Z', '${t.magZ.round()}'),
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.instrumentMark,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}