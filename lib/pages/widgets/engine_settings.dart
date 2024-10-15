import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/flight_settings_bloc/fligh_settings_bloc.dart';
import 'package:paperwings/bloc/flight_settings_bloc/fligh_settings_event.dart';
import 'package:paperwings/bloc/flight_settings_bloc/fligh_settings_state.dart';
import 'package:paperwings/models/flight_settings.dart';

class EngineSettings extends StatefulWidget {
  final Function(FlightSettings) onSettingsChanged;
  final VoidCallback onFactorySettings;
  final VoidCallback onDone;

  const EngineSettings({
    super.key,
    required this.onSettingsChanged,
    required this.onFactorySettings,
    required this.onDone,
  });

  @override
  State<EngineSettings> createState() => _EngineSettingsState();
}

class _EngineSettingsState extends State<EngineSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightSettingsBloc, FlightSettingsState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
          child: Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "AIRCRAFT SETTINGS",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 30.0),

                  _buildSlider(
                    "Steering Angle",
                    state.flightSettings.steeringAngle,
                    Icons.set_meal,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdateSteeringAngle(value));
                    },
                    min: 5,
                    max: 175,
                    divisions: 35,
                  ),
                  _buildSlider(
                    "Pitch Kp",
                    state.flightSettings.pitchKp,
                    Icons.arrow_upward,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdatePitchKp(value));
                    },
                    min: 0,
                    max: 2.540,
                    divisions: 254,
                  ),
                  _buildSlider(
                    "Pitch Rate Kp",
                    state.flightSettings.pitchRateKp,
                    Icons.arrow_downward,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdatePitchRateKp(value));
                    },
                    min: 0,
                    max: 2.540,
                    divisions: 254,
                  ),
                  _buildSlider(
                    "Roll Kp",
                    state.flightSettings.rollKp,
                    Icons.arrow_forward,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdateRollKp(value));
                    },
                    min: 0,
                    max: 2.540,
                    divisions: 254,
                  ),
                  _buildSlider(
                    "Roll Rate Kp",
                    state.flightSettings.rollRateKp,
                    Icons.arrow_back,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdateRollRateKp(value));
                    },
                    min: 0,
                    max: 2.540,
                    divisions: 254,
                  ),
                  _buildSlider(
                    "Yaw Kp",
                    state.flightSettings.yawKp,
                    Icons.rotate_left,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdateYawKp(value));
                    },
                    min: 0,
                    max: 2.540,
                    divisions: 254,
                  ),
                  _buildSlider(
                    "Yaw Rate Kp",
                    state.flightSettings.yawRateKp,
                    Icons.rotate_right,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdateYawRateKp(value));
                    },
                    min: 0,
                    max: 2.540,
                    divisions: 254,
                  ),
                  _buildSlider(
                    "Angle of Attack",
                    state.flightSettings.angleOfAttack,
                    Icons.accessibility,
                    (value) {
                      context
                          .read<FlightSettingsBloc>()
                          .add(UpdateAngleOfAttack(value));
                    },
                    min: 0,
                    max: 90,
                    divisions: 90,
                  ),
                  // Agrega los otros sliders de la misma forma...
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<FlightSettingsBloc>()
                          .add(ResetFactorySettings());
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      widget.onDone();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'DONE',
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
            Icon(
              icon,
              color: Colors.blue,
            ),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
                divisions: divisions, // Establece los incrementos
                activeColor: Colors.blue,
                inactiveColor: Colors.white.withOpacity(0.5),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
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
