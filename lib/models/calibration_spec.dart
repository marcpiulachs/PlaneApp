import 'package:flutter/material.dart';

class CalibrationInstruction {
  final String text;
  final bool isWarning;

  const CalibrationInstruction(this.text, {this.isWarning = false});
}

/// Configuración de un flujo de calibración guiado, reutilizable tanto en
/// una página como en un overlay.
class CalibrationSpec {
  final String title;
  final IconData icon;
  final List<CalibrationInstruction> instructions;
  final void Function(BuildContext context) onStart;

  const CalibrationSpec({
    required this.title,
    required this.icon,
    required this.instructions,
    required this.onStart,
  });
}