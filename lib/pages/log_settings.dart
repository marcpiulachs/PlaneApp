import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';

class LogSettings extends StatefulWidget {
  const LogSettings({super.key});

  @override
  State<LogSettings> createState() => _LogSettingsState();
}

class _LogSettingsState extends State<LogSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneSettingsBloc, PlaneSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Serial port logging",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOptionTile(
                    name: "IMU",
                    isSelected: state.logSettings.imu,
                    onChanged: (bool newValue) {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        UpdateIMULogEvent(newValue),
                      );
                    },
                  ),
                  _buildOptionTile(
                    name: "Thrust",
                    isSelected: state.logSettings.thrust,
                    onChanged: (bool newValue) {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        UpdateThrustLogEvent(newValue),
                      );
                    },
                  ),
                  _buildOptionTile(
                    name: "Battery",
                    isSelected: state.logSettings.battery,
                    onChanged: (bool newValue) {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        UpdateBatteryLogEvent(newValue),
                      );
                    },
                  ),
                  _buildOptionTile(
                    name: "Motor",
                    isSelected: state.logSettings.motor,
                    onChanged: (bool newValue) {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        UpdateMotorLogEvent(newValue),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Construye un ListTile para mostrar una opción.
  Widget _buildOptionTile({
    required String name,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bug_report,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          activeColor: Colors.black,
        ),
      ),
    );
  }
}
