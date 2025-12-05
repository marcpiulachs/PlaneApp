import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';

class BeaconSettings extends StatefulWidget {
  const BeaconSettings({
    super.key,
  });

  @override
  State<BeaconSettings> createState() => _BeaconSettingsState();
}

class _BeaconSettingsState extends State<BeaconSettings> {
  final List<String> options = [
    'Blinking very fast', // STROBE
    'Blinking slow', // LONG_BLINK
    'Blinking fast', // SHORT_BLINKS
    'Alternating', // ALTERNATING
    'Double blink', // DOUBLE_BLINK
    'Wigwag', // WIGWAG
    'Rotating', // ROTATING
    'Emergency', // EMERGENCY
    'Disabled', // NONE
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaneSettingsBloc, PlaneSettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Beacon settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final optionName = options[index];
                    return ListTile(
                      leading: Container(
                        width: 40, // Tamaño del círculo
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.black, // Fondo negro para el círculo
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb,
                          color: Colors.white, // Ícono blanco para contraste
                          size: 24,
                        ),
                      ),
                      title: Text(
                        optionName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
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
