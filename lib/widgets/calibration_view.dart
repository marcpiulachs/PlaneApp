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
            Icon(spec.icon, size: 60, color: AppTheme.textSecondary),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              message,
              style: AppTheme.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacingXl),
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.white,
              ),
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
            padding: const EdgeInsets.all(AppSpacing.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(spec.icon,
                        color: AppTheme.textSecondary, size: 28),
                    const SizedBox(width: AppSpacing.spacingMd),
                    Expanded(
                      child: Text(spec.title, style: AppTheme.heading3),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                const ListTile(
                  leading: IconCircle(icon: Icons.menu_book),
                  title:
                      Text('Instrucciones', style: AppTheme.bodyLarge),
                  contentPadding: EdgeInsets.zero,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: AppSpacing.spacingXl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final instruction in spec.instructions)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppSpacing.spacingSm),
                          child: InstructionItem(
                            text: instruction.text,
                            isWarning: instruction.isWarning,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
    return Column(
      children: [
        icon,
        const SizedBox(height: AppSpacing.spacingLg),
        Text(
          message,
          style: style,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}