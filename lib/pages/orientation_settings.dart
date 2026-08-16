import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/models/settings_option.dart';
import 'package:paperwings/widgets/icon_circle.dart';

class OrientationSettings extends StatefulWidget {
  const OrientationSettings({
    super.key,
  });

  @override
  State<OrientationSettings> createState() => _OrientationSettingsState();
}

class _OrientationSettingsState extends State<OrientationSettings> {
  final List<SettingsOption> options = [
    SettingsOption(
      title: 'Flat',
      description: 'PCB horizontal, components up',
      icon: Icons.arrow_upward,
    ),
    SettingsOption(
      title: 'Rotated Right',
      description: 'PCB vertical, components to the right',
      icon: Icons.arrow_forward,
    ),
    SettingsOption(
      title: 'Rotated Left',
      description: 'PCB vertical, components to the left',
      icon: Icons.arrow_back,
    ),
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
                child: RadioGroup<int>(
                  groupValue: state.flightSettings.imuOrientation,
                  onChanged: (value) {
                    if (value != null) {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        UpdateImuOrientation(value),
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
            ),
          ],
        );
      },
    );
  }
}