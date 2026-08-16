import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class IconCircle extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const IconCircle({
    super.key,
    required this.icon,
    this.size = 40,
    this.backgroundColor = AppTheme.buttonColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size * 0.6,
      ),
    );
  }
}