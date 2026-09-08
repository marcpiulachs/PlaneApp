import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_event.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';

class CalibrationBloc extends Bloc<CalibrationEvent, CalibrationState> {
  final IPlaneClient client;

  CalibrationBloc(this.client) : super(CalibrationInitial()) {
    on<CalibrateImuEvent>((event, emit) async {
      emit(CalibrationInProgress(
          'Coloca el avión en una superficie plana y espera...'));
      try {
        await client.sendCalibrateIMU();
        await Future.delayed(const Duration(seconds: 3));
        emit(CalibrationSuccess(
            'Calibración de acelerómetro y giroscopio completada.'));
      } catch (e) {
        emit(CalibrationFailure('Error en calibración IMU'));
      }
    });

    on<CalibrateCompassEvent>((event, emit) async {
      emit(CalibrationInProgress('Mueve el avión en todas direcciones...'));
      try {
        await client.sendCalibrateMAG();
        await Future.delayed(const Duration(seconds: 10));
        emit(CalibrationSuccess('Calibración de magnetómetro completada.'));
      } catch (e) {
        emit(CalibrationFailure('Error en calibración de magnetómetro'));
      }
    });
  }
}