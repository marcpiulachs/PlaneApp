import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class Connecting extends StatelessWidget {
  const Connecting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.airplanemode_active,
            size: 120,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Connecting ...',
            style: AppTheme.heading3,
          ),
        ],
      ),
    );
  }
}
