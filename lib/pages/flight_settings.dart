import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/full_width_button.dart';
import 'package:paperwings/widgets/icon_circle.dart';

class EngineSettings extends StatefulWidget {
  const EngineSettings({
    super.key,
  });

  @override
  State<EngineSettings> createState() => _EngineSettingsState();
}

class _EngineSettingsState extends State<EngineSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneSettingsBloc, PlaneSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Fine tune your plane",
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pitch PID
                    _buildSlider(
                      "Pitch Kp",
                      state.flightSettings.pitchKp,
                      Icons.arrow_upward,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdatePitchKp(value),
                            );
                      },
                      min: 0,
                      max: 5.0,
                      divisions: 500,
                      description:
                          "Ganancia proporcional para pitch. Controla qué tan rápido responde el avión a cambios de ángulo.",
                    ),
                    _buildSlider(
                      "Pitch Ki",
                      state.flightSettings.pitchKi,
                      Icons.arrow_upward,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdatePitchKi(value),
                            );
                      },
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      description:
                          "Ganancia integral para pitch. Corrige errores acumulados a lo largo del tiempo.",
                    ),
                    _buildSlider(
                      "Pitch Kd",
                      state.flightSettings.pitchKd,
                      Icons.arrow_upward,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdatePitchKd(value),
                            );
                      },
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      description:
                          "Ganancia derivativa para pitch. Reduce oscilaciones y suaviza el movimiento.",
                    ),
                    // Roll PID
                    _buildSlider(
                      "Roll Kp",
                      state.flightSettings.rollKp,
                      Icons.arrow_forward,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdateRollKp(value),
                            );
                      },
                      min: 0,
                      max: 5.0,
                      divisions: 500,
                      description:
                          "Ganancia proporcional para roll. Controla la rapidez de respuesta al inclinar el avión.",
                    ),
                    _buildSlider(
                      "Roll Ki",
                      state.flightSettings.rollKi,
                      Icons.arrow_forward,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdateRollKi(value),
                            );
                      },
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      description:
                          "Ganancia integral para roll. Corrige errores de inclinación persistentes.",
                    ),
                    _buildSlider(
                      "Roll Kd",
                      state.flightSettings.rollKd,
                      Icons.arrow_forward,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdateRollKd(value),
                            );
                      },
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      description:
                          "Ganancia derivativa para roll. Estabiliza el avión durante giros.",
                    ),
                    // Yaw PID
                    _buildSlider(
                      "Yaw Kp",
                      state.flightSettings.yawKp,
                      Icons.rotate_left,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdateYawKp(value),
                            );
                      },
                      min: 0,
                      max: 5.0,
                      divisions: 500,
                      description:
                          "Ganancia proporcional para yaw. Controla la rotación del avión sobre su eje vertical.",
                    ),
                    _buildSlider(
                      "Yaw Ki",
                      state.flightSettings.yawKi,
                      Icons.rotate_left,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdateYawKi(value),
                            );
                      },
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      description:
                          "Ganancia integral para yaw. Corrige la deriva lateral acumulada durante el vuelo.",
                    ),
                    _buildSlider(
                      "Yaw Kd",
                      state.flightSettings.yawKd,
                      Icons.rotate_left,
                      (value) {
                        context.read<PlaneSettingsBloc>().add(
                              UpdateYawKd(value),
                            );
                      },
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      description:
                          "Ganancia derivativa para yaw. Reduce oscilaciones en la dirección del avión.",
                    ),
                    const SizedBox(height: AppSpacing.spacingLg),
                    FullWidthButton(
                      label: 'GUARDAR PID',
                      onPressed: () {
                        context
                            .read<PlaneSettingsBloc>()
                            .add(CommitAllPidSettings());
                      },
                    ),
                    const SizedBox(height: AppSpacing.spacingXl),
                    FullWidthButton(
                      label: 'FACTORY SETTINGS',
                      onPressed: () {
                        context.read<PlaneSettingsBloc>().add(
                              ResetFactorySettings(),
                            );
                      },
                    ),
                    const SizedBox(height: AppSpacing.spacingXl),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    IconData icon,
    Function(double) onChanged, {
    double min = 0.0,
    double max = 100.0,
    int divisions = 10,
    String? description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTheme.labelMedium,
            ),
            if (description != null) ...[
              const SizedBox(width: AppSpacing.spacingSm),
              Tooltip(
                message: description,
                padding: const EdgeInsets.all(AppSpacing.spacingMd),
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark,
                  borderRadius: BorderRadius.circular(AppRadius.radiusSm),
                ),
                textStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.spacingXs, bottom: AppSpacing.spacingXs),
            child: Text(
              description,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        Row(
          children: [
            IconCircle(icon: icon),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
                divisions: divisions, // Establece los incrementos
                activeColor: Colors.white,
                inactiveColor: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppTheme.buttonColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                value.toStringAsFixed(1), // Mantiene el formato decimal
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
