import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc.dart';

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInstructionItem(
                              '1. Presiona el botón "Iniciar Calibración".'),
                          const SizedBox(height: 8),
                          _buildInstructionItem(
                              '2. Mueve el avión lentamente en todas las direcciones.'),
                          const SizedBox(height: 8),
                          _buildInstructionItem(
                              '3. Realiza rotaciones completas en los 3 ejes (pitch, roll, yaw).'),
                          const SizedBox(height: 8),
                          _buildInstructionItem(
                              '4. Continúa moviendo el avión hasta que se complete el contador.'),
                          const SizedBox(height: 8),
                          _buildInstructionItem(
                              '5. La calibración durará 10 segundos.',
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Iniciar Calibración',
                            style: TextStyle(fontSize: 18),
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

  Widget _buildInstructionItem(String text, {bool isWarning = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isWarning ? Icons.warning : Icons.check,
          color: isWarning ? Colors.orange : Colors.white,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isWarning ? Colors.orange : Colors.white,
              fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
