import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/orientation_bloc.dart';

import 'package:paperwings/pages/widgets/instruments/paper_plane.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

class SettingsOrientationPage extends StatelessWidget {
  const SettingsOrientationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lanzar el evento de inicio solo si es necesario
    context.read<OrientationBloc>().add(OrientationStart());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<OrientationBloc, OrientationState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OrientationObject(
                  label: 'Yaw',
                  roll: 0,
                  pitch: 0,
                  yaw: state.yaw,
                ),
                const SizedBox(height: 16),
                _OrientationObject(
                  label: 'Pitch',
                  roll: 0,
                  pitch: state.pitch,
                  yaw: 0,
                ),
                const SizedBox(height: 16),
                _OrientationObject(
                  label: 'Roll',
                  roll: state.roll,
                  pitch: 0,
                  yaw: 0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrientationObject extends StatelessWidget {
  final String label;
  final double roll;
  final double pitch;
  final double yaw;

  const _OrientationObject({
    required this.label,
    required this.roll,
    required this.pitch,
    required this.yaw,
  });

  @override
  Widget build(BuildContext context) {
    double angle = 0;
    if (label.toLowerCase() == 'roll') {
      angle = roll;
    } else if (label.toLowerCase() == 'pitch') {
      angle = pitch;
    } else if (label.toLowerCase() == 'yaw') {
      angle = yaw;
    }
    return Column(
      children: [
        Text('$label: ${angle.toStringAsFixed(2)}°',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          width: 150,
          height: 150,
          child: PaperPlane3D(roll: roll, pitch: pitch, yaw: yaw),
        ),
      ],
    );
  }
}
