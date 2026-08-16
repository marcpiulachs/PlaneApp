import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/models/settings_option.dart';
import 'package:paperwings/widgets/icon_circle.dart';

class BeaconSettings extends StatefulWidget {
  const BeaconSettings({
    super.key,
  });

  @override
  State<BeaconSettings> createState() => _BeaconSettingsState();
}

class _BeaconSettingsState extends State<BeaconSettings> {
  final List<SettingsOption> options = [
    SettingsOption(
      title: 'Disabled',
      description: 'Both lights off',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Steady On',
      description: 'LED 1 steady on',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Steady Both',
      description: 'Both LEDs steady on',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Short Blinks',
      description: '3 quick blinks',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Long Blink',
      description: 'Alternates with long on-times',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Alternating',
      description: 'Alternates between the two LEDs',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Strobe',
      description: 'Fast strobe burst',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'SOS',
      description: 'International emergency pattern',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Wigwag',
      description: 'Fast alternating, patrol style',
      icon: Icons.lightbulb,
    ),
    SettingsOption(
      title: 'Rotating',
      description: 'Simulates rotation between the two LEDs',
      icon: Icons.lightbulb,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneSettingsBloc, PlaneSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Beacon settings",
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Expanded(
              child: Padding(
                padding: AppSpacing.listPadding,
                child: RadioGroup<int>(
                  groupValue: state.flightSettings.beacon,
                  onChanged: (value) {
                    if (value != null) {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        UpdateBeacon(value),
                      );
                    }
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return ListTile(
                        leading: IconCircle(icon: option.icon),
                        title: Text(
                          option.title,
                          style: AppTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          option.description,
                          style: AppTheme.bodyMedium,
                        ),
                        trailing: Radio<int>(
                          value: index,
                          // Color del radio cuando está seleccionado
                          activeColor: Colors.black,
                        ),
                        onTap: () {
                          BlocProvider.of<PlaneSettingsBloc>(context).add(
                            UpdateBeacon(index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
