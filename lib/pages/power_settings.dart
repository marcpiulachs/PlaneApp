import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';

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
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
