import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/full_width_button.dart';

class PowerSettings extends StatefulWidget {
  const PowerSettings({super.key});

  @override
  State<PowerSettings> createState() => _PowerSettingsState();
}

class _PowerSettingsState extends State<PowerSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneSettingsBloc, PlaneSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Power",
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomButton(
                    title: "Power Off",
                    onPressed: () {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        ShutdownEvent(),
                      );
                    },
                  ),
                  _buildCustomButton(
                    title: "Reboot",
                    onPressed: () {
                      BlocProvider.of<PlaneSettingsBloc>(context).add(
                        RebootEvent(),
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

  Widget _buildCustomButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacingMd),
      child: FullWidthButton(
        label: title,
        onPressed: onPressed,
      ),
    );
  }
}
