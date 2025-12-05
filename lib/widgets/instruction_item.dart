import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class InstructionItem extends StatelessWidget {
  final String text;
  final bool isWarning;

  const InstructionItem({
    super.key,
    required this.text,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isWarning ? Icons.warning : Icons.check_circle,
          color: isWarning ? AppTheme.warning : Colors.black,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyMedium.copyWith(
              color: isWarning ? AppTheme.warning : Colors.white,
              fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
