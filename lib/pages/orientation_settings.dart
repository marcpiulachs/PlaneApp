import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/icon_circle.dart';

class OrientationSettings extends StatefulWidget {
  const OrientationSettings({
    super.key,
  });

  @override
  State<OrientationSettings> createState() => _OrientationSettingsState();
}

class _OrientationSettingsState extends State<OrientationSettings> {
  final List<String> options = [
    'Flat', // FLAT
    'Rotated Right', // ROLL_RIGHT_90
    'Rotated Left', // ROLL_LEFT_90
  ];

  final List<IconData> icons = [
    Icons.arrow_upward, // FLAT (plano)
    Icons.arrow_forward, // ROLL_RIGHT_90 (derecha)
    Icons.arrow_back, // ROLL_LEFT_90 (izquierda)
  ];

  final List<String> descriptions = [
    'PCB horizontal, components up',
    'PCB vertical, components to the right',
    'PCB vertical, components to the left',
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneSettingsBloc, PlaneSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "IMU orientation settings",
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
                      leading: IconCircle(icon: icons[index]),
                      title: Text(
                        optionName,
                        style: AppTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        descriptions[index],
                        style: AppTheme.bodyMedium,
                      ),
                      trailing: Radio<int>(
                        value: index,
                        groupValue: state.flightSettings.imuOrientation,
                        onChanged: (value) {
                          if (value != null) {
                            BlocProvider.of<PlaneSettingsBloc>(context).add(
                              UpdateImuOrientation(value),
                            );
                          }
                        },
                        activeColor: Colors.black,
                      ),
                      onTap: () {
                        BlocProvider.of<PlaneSettingsBloc>(context).add(
                          UpdateImuOrientation(index),
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