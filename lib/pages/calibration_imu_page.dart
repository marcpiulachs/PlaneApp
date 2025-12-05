import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/instruction_item.dart';

class CalibrationImuPage extends StatelessWidget {
  const CalibrationImuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalibrationBloc, CalibrationState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              "Calibración Acelerómetro/Giroscopio",
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
                          Icons.straighten,
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
                                  '1. Coloca el avión en una superficie completamente plana y nivelada.'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text:
                                  '2. Asegúrate de que el avión esté inmóvil.'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text:
                                  '3. Presiona el botón "Iniciar Calibración".'),
                          const SizedBox(height: 8),
                          const InstructionItem(
                              text:
                                  '4. No muevas el avión durante el proceso.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is CalibrationInProgress)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                                color: Colors.white),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
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
                              size: 60,
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
                              size: 60,
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
                                .add(CalibrateImuEvent());
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
