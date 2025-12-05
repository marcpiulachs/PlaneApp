import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/instruction_item.dart';

class CalibrationMagPage extends StatelessWidget {
  const CalibrationMagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Calibración Magnetómetro",
              style: AppTheme.heading3,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.explore,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      title: const Text(
                        'Instrucciones',
                        style: AppTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const InstructionItem(
                              text:
                                  '1. Presiona el botón "Iniciar Calibración".'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text:
                                  '2. Mueve el avión lentamente en todas las direcciones.'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text:
                                  '3. Realiza rotaciones completas en los 3 ejes (pitch, roll, yaw).'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text:
                                  '4. Continúa moviendo el avión hasta que se complete el contador.'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text: '5. La calibración durará 10 segundos.',
                              isWarning: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is CalibrationInProgress)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 8,
                                    color: Colors.white,
                                    value: state.secondsRemaining != null
                                        ? (10 - state.secondsRemaining!) / 10
                                        : null,
                                  ),
                                ),
                                if (state.secondsRemaining != null)
                                  Text(
                                    '${state.secondsRemaining}',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              state.message,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Icon(
                              Icons.rotate_right,
                              size: 60,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    else if (state is CalibrationSuccess)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else if (state is CalibrationFailure)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.error,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (state is! CalibrationInProgress)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<CalibrationBloc>()
                                .add(CalibrateCompassEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Iniciar Calibración',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
