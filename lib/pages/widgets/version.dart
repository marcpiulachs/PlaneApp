import 'package:flutter/material.dart';
import 'package:paperwings/models/verison.dart';
import 'package:paperwings/config/app_theme.dart';

class Versions extends StatelessWidget {
  final Version appVersion;
  final Version devVersion;

  const Versions({
    super.key,
    required this.appVersion,
    required this.devVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'App version',
          style: AppTheme.heading3.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          appVersion.toString(),
          style: AppTheme.heading1.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 16),
        Text(
          'Firmware version',
          style: AppTheme.heading3.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          devVersion.toString(),
          style: AppTheme.heading1.copyWith(fontSize: 25),
        )
      ],
    );
  }
}
