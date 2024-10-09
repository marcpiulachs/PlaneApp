import 'package:flutter/material.dart';
import 'package:paperwings/core/flight_settings.dart';

class EngineSettings extends StatefulWidget {
  final FlightSettings settings;
  final Function(FlightSettings) onSettingsChanged;
  final VoidCallback onFactorySettings;
  final VoidCallback onDone;

  const EngineSettings({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onFactorySettings,
    required this.onDone,
  });

  @override
  State<EngineSettings> createState() => _EngineSettingsState();
}

class _EngineSettingsState extends State<EngineSettings> {
  late FlightSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateSetting(double value, Function(double) updateFunc) {
    setState(() {
      updateFunc(value);
    });
    widget.onSettingsChanged(_settings);
  }

  @override
  Widget build(BuildContext context) {
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
                _settings.steeringAngle,
                Icons.set_meal,
                (value) {
                  _updateSetting(value, _settings.updateSteeringAngle);
                },
                min: 5,
                max: 175,
                divisions: 35,
              ),
              _buildSlider(
                "Pitch Kp",
                _settings.pitchKp,
                Icons.arrow_upward,
                (value) {
                  _updateSetting(value, _settings.updatePitchKp);
                },
                min: 0,
                max: 2.540,
                divisions: 254,
              ),
              _buildSlider(
                "Pitch Rate Kp",
                _settings.pitchRateKp,
                Icons.arrow_downward,
                (value) {
                  _updateSetting(value, _settings.updatePitchRateKp);
                },
                min: 0,
                max: 2.540,
                divisions: 254,
              ),
              _buildSlider(
                "Roll Kp",
                _settings.rollKp,
                Icons.arrow_forward,
                (value) {
                  _updateSetting(value, _settings.updateRollKp);
                },
                min: 0,
                max: 2.540,
                divisions: 254,
              ),
              _buildSlider(
                "Roll Rate Kp",
                _settings.rollRateKp,
                Icons.arrow_back,
                (value) {
                  _updateSetting(value, _settings.updateRollRateKp);
                },
                min: 0,
                max: 2.540,
                divisions: 254,
              ),
              _buildSlider(
                "Yaw Kp",
                _settings.yawKp,
                Icons.rotate_left,
                (value) {
                  _updateSetting(value, _settings.updateYawKp);
                },
                min: 0,
                max: 2.540,
                divisions: 254,
              ),
              _buildSlider(
                "Yaw Rate Kp",
                _settings.yawRateKp,
                Icons.rotate_right,
                (value) {
                  _updateSetting(value, _settings.updateYawRateKp);
                },
                min: 0,
                max: 2.540,
                divisions: 254,
              ),
              _buildSlider(
                "Angle of Attack",
                _settings.angleOfAttack,
                Icons.accessibility,
                (value) {
                  _updateSetting(value, _settings.updateAngleOfAttack);
                },
                min: 0,
                max: 90,
                divisions: 90,
              ),
              const SizedBox(height: 20.0),
              Column(children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onFactorySettings();
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
                    // Llamar al callback
                    widget.onDone();
                    // Cerrar el BottomSheet
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
                )
              ]),
            ],
          ),
        ),
      ),
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
