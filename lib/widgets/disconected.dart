import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/instruction_item.dart';

class Disconnected extends StatelessWidget {
  final VoidCallback onConnect; // Agregamos el callback aquí

  const Disconnected({super.key, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.airplanemode_inactive,
            size: 100.0,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          const Text(
            'Disconnected',
            style: AppTheme.heading1,
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestions:',
                  style: AppTheme.heading3,
                ),
                SizedBox(height: 16),
                InstructionItem(text: 'Check your plane is turned ON.'),
                SizedBox(height: 12),
                InstructionItem(
                    text:
                        'Ensure you are connected to the WiFi network created by your plane.'),
                SizedBox(height: 12),
                InstructionItem(
                    text:
                        'Verify you have your phone cellular data turned OFF.'),
              ],
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: onConnect,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(50, 50),
            ),
            child: const Text(
              'CONNECT',
              style: AppTheme.heading3,
            ),
          ),
        ],
      ),
    );
  }
}
