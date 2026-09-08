import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_event.dart';
import 'package:paperwings/models/calibration_spec.dart';

CalibrationSpec imuCalibrationSpec() => CalibrationSpec(
      title: 'Calibración Acelerómetro/Giroscopio',
      icon: Icons.straighten,
      instructions: const [
        CalibrationInstruction(
            '1. Coloca el avión en una superficie completamente plana y nivelada.'),
        CalibrationInstruction('2. Asegúrate de que el avión esté inmóvil.'),
        CalibrationInstruction('3. Presiona el botón "Iniciar Calibración".'),
        CalibrationInstruction('4. No muevas el avión durante el proceso.'),
      ],
      onStart: (context) =>
          context.read<CalibrationBloc>().add(CalibrateImuEvent()),
    );

CalibrationSpec magCalibrationSpec() => CalibrationSpec(
      title: 'Calibración Magnetómetro',
      icon: Icons.explore,
      instructions: const [
        CalibrationInstruction('1. Presiona el botón "Iniciar Calibración".'),
        CalibrationInstruction(
            '2. Mueve el avión lentamente en todas las direcciones.'),
        CalibrationInstruction(
            '3. Realiza rotaciones completas en los 3 ejes (pitch, roll, yaw).'),
        CalibrationInstruction(
            '4. Mantén el avión en movimiento durante los 10 segundos de calibración.',
            isWarning: true),
      ],
      onStart: (context) =>
          context.read<CalibrationBloc>().add(CalibrateCompassEvent()),
    );