import 'package:flutter/material.dart';
import 'package:object_3d/core/flight_settings.dart';

class EngineSettingsBottomSheet extends StatefulWidget {
  final FlightSettings settings;
  final Function(FlightSettings) onSettingsChanged;
  final VoidCallback onFactorySettings;
  final VoidCallback onDone;

  const EngineSettingsBottomSheet({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onFactorySettings,
    required this.onDone,
  });

  @override
  State<EngineSettingsBottomSheet> createState() =>
      _EngineSettingsBottomSheetState();
}

class _EngineSettingsBottomSheetState extends State<EngineSettingsBottomSheet> {
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
        color: Colors.black,
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
                  "Steering Angle", _settings.steeringAngle, Icons.set_meal,
                  (value) {
                _updateSetting(value, _settings.updateSteeringAngle);
              }),
              _buildSlider("Pitch Kp", _settings.pitchKp, Icons.arrow_upward,
                  (value) {
                _updateSetting(value, _settings.updatePitchKp);
              }),
              _buildSlider(
                  "Pitch Rate Kp", _settings.pitchRateKp, Icons.arrow_downward,
                  (value) {
                _updateSetting(value, _settings.updatePitchRateKp);
              }),
              _buildSlider("Roll Kp", _settings.rollKp, Icons.arrow_forward,
                  (value) {
                _updateSetting(value, _settings.updateRollKp);
              }),
              _buildSlider(
                  "Roll Rate Kp", _settings.rollRateKp, Icons.arrow_back,
                  (value) {
                _updateSetting(value, _settings.updateRollRateKp);
              }),
              _buildSlider("Yaw Kp", _settings.yawKp, Icons.rotate_left,
                  (value) {
                _updateSetting(value, _settings.updateYawKp);
              }),
              _buildSlider(
                  "Yaw Rate Kp", _settings.yawRateKp, Icons.rotate_right,
                  (value) {
                _updateSetting(value, _settings.updateYawRateKp);
              }),
              _buildSlider("Angle of Attack", _settings.angleOfAttack,
                  Icons.accessibility, (value) {
                _updateSetting(value, _settings.updateAngleOfAttack);
              }),
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
      String label, double value, IconData icon, Function(double) onChanged) {
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
                min: 0.0,
                max: 100.0,
                onChanged: onChanged,
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
                value.toStringAsFixed(1),
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
