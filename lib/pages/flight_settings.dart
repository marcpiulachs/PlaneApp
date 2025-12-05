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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PlaneSettingsBloc>().add(
                                  ResetFactorySettings(),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'FACTORY SETTINGS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    int divisions = 10, // Número de incrementos
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
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
