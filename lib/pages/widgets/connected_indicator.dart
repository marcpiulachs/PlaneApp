import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class ConnectedIndicator extends StatelessWidget {
  final bool isConnected;

  const ConnectedIndicator({
    super.key,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2), // Sombra hacia abajo
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.public : Icons.public_off,
              size: 18,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: AppTheme.heading3.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
