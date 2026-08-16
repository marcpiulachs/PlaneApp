import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/models/recorded_item.dart';

class FlightStatusCard extends StatelessWidget {
  final RecordedFlight flight;

  const FlightStatusCard({
    super.key,
    required this.flight,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = flight.hasCrash
        ? AppTheme.error
        : (flight.hasEmergency ? AppTheme.warning : AppTheme.success);
    final statusText = flight.hasCrash
        ? 'CRASH'
        : (flight.hasEmergency ? 'EMERGENCIA' : 'COMPLETADO');

    return Card(
      color: AppTheme.cardColor,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    flight.hasCrash ? Icons.warning : Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        flight.formattedDate,
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Divider(color: AppTheme.surfaceDarker),
            const SizedBox(height: AppSpacing.spacingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat(
                    'Duración', flight.formattedDuration, Icons.timer),
                _buildQuickStat(
                    'Puntos', '${flight.telemetryData.length}', Icons.analytics),
                _buildQuickStat('Frecuencia', '10 Hz', Icons.insights),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 24),
        const SizedBox(height: AppSpacing.spacingXs),
        Text(
          value,
          style: AppTheme.statValue,
        ),
        Text(
          label,
          style: AppTheme.statLabel,
        ),
      ],
    );
  }
}