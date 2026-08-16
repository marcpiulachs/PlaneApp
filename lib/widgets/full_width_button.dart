import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class FullWidthButton extends StatelessWidget {
  final String label;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const FullWidthButton({
    super.key,
    this.label = '',
    this.child,
    this.onPressed,
    this.backgroundColor = AppTheme.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: backgroundColor,
      ),
      child: child ?? Text(label),
    );
  }
}