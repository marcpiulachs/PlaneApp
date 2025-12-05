import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<PlaneSettingsBloc>()
                            .add(CommitAllPidSettings());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('GUARDAR PID'),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PlaneSettingsBloc>().add(
                              ResetFactorySettings(),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('FACTORY SETTINGS'),
                    ),
                    const SizedBox(height: 20),
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (description != null) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: description,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        Row(
          children: [
            Container(
              width: 40, // Tamaño del círculo
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black, // Fondo negro para el círculo
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
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
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Text(
                value.toStringAsFixed(1), // Mantiene el formato decimal
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
