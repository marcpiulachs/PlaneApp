import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_state.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/models/calibration_spec.dart';
import 'package:paperwings/widgets/full_width_button.dart';
import 'package:paperwings/widgets/icon_circle.dart';
import 'package:paperwings/widgets/instruction_item.dart';

/// Vista de calibración reutilizable: instrucciones + botón, y durante el
/// proceso muestra "Calibrando…" en lugar del contenido (igual que la pantalla
/// de conexión alterna entre instrucciones y "Connecting…").
class CalibrationView extends StatelessWidget {
  final CalibrationSpec spec;

  const CalibrationView({super.key, required this.spec});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
      builder: (context, state) {
        if (state is CalibrationInProgress) {
          return _Calibrating(spec: spec, message: state.message);
        }
        return _CalibrationForm(spec: spec, state: state);
      },
    );
  }
}

class _Calibrating extends StatelessWidget {
  final CalibrationSpec spec;
  final String message;

  const _Calibrating({required this.spec, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox.expand(
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Colors.white,
                    ),
                  ),
                  IconCircle(icon: spec.icon, size: 72),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingXl),
            Text(
              message,
              style: AppTheme.heading3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalibrationForm extends StatelessWidget {
  final CalibrationSpec spec;
  final CalibrationState state;

  const _CalibrationForm({required this.spec, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: IconCircle(icon: spec.icon, size: 72)),
                const SizedBox(height: AppSpacing.spacingLg),
                Text(
                  spec.title,
                  style: AppTheme.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spacingXl),
                _InstructionsSection(instructions: spec.instructions),
                const SizedBox(height: AppSpacing.spacingLg),
                if (state is CalibrationSuccess)
                  _Result(
                    icon: const Icon(Icons.check_circle,
                        color: Colors.green, size: 60),
                    message: (state as CalibrationSuccess).message,
                    style: AppTheme.statusSuccess,
                  )
                else if (state is CalibrationFailure)
                  _Result(
                    icon: const Icon(Icons.error,
                        color: Colors.red, size: 60),
                    message: (state as CalibrationFailure).error,
                    style: AppTheme.statusError,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.pagePadding,
          child: FullWidthButton(
            label: 'Iniciar Calibración',
            onPressed: () => spec.onStart(context),
          ),
        ),
      ],
    );
  }
}

class _InstructionsSection extends StatelessWidget {
  final List<CalibrationInstruction> instructions;

  const _InstructionsSection({required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.menu_book,
                color: AppTheme.textSecondary, size: 20),
            SizedBox(width: AppSpacing.spacingMd),
            Text('Instrucciones', style: AppTheme.labelLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.spacingLg),
        for (final instruction in instructions)
          Padding(
            padding:
                const EdgeInsets.only(bottom: AppSpacing.spacingSm),
            child: InstructionItem(
              text: instruction.text,
              isWarning: instruction.isWarning,
            ),
          ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  final Widget icon;
  final String message;
  final TextStyle style;

  const _Result({
    required this.icon,
    required this.message,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(height: AppSpacing.spacingLg),
          Text(
            message,
            style: style,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}