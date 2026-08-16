import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/icon_circle.dart';

class BeaconSettings extends StatefulWidget {
  const BeaconSettings({
    super.key,
  });

  @override
  State<BeaconSettings> createState() => _BeaconSettingsState();
}

class _BeaconSettingsState extends State<BeaconSettings> {
  final List<String> options = [
    'Disabled', // NONE
    'Steady On', // STEADY_ON
    'Steady Both', // STEADY_BOTH
    'Short Blinks', // SHORT_BLINKS
    'Long Blink', // LONG_BLINK
    'Alternating', // ALTERNATING
    'Strobe', // STROBE
    'SOS', // SOS
    'Wigwag', // WIGWAG
    'Rotating', // ROTATING
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
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final optionName = options[index];
                    return ListTile(
                      leading: const IconCircle(icon: Icons.lightbulb),
                      title: Text(
                        optionName,
                        style: AppTheme.bodyLarge,
                      ),
                      trailing: Radio<int>(
                        value: index,
                        groupValue: state.flightSettings.beacon,
                        onChanged: (value) {
                          if (value != null) {
                            BlocProvider.of<PlaneSettingsBloc>(context).add(
                              UpdateBeacon(value),
                            );
                          }
                        },
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
          ],
        );
      },
    );
  }
}
