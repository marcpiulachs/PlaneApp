import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

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
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.white,
                  ), // Punto
                  title: Text(
                    'Check your plane is turned ON.',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero, // Para alinear los textos
                ),
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.white,
                  ), // Punto
                  title: Text(
                    'Ensure you are connected to the WiFi network created by your plane.',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.white,
                  ), // Punto
                  title: Text(
                    'Verify you have your phone cellular data turned OFF.',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
