import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../clients/plane_client_interface.dart';

abstract class CalibrationEvent {}

class CalibrateImuEvent extends CalibrationEvent {}

class CalibrateCompassEvent extends CalibrationEvent {}

class CalibrationTickEvent extends CalibrationEvent {
  final int secondsRemaining;
  CalibrationTickEvent(this.secondsRemaining);
}

abstract class CalibrationState {}

class CalibrationInitial extends CalibrationState {}

class CalibrationInProgress extends CalibrationState {
  final String message;
  final int? secondsRemaining;
  CalibrationInProgress(this.message, {this.secondsRemaining});
}

class CalibrationSuccess extends CalibrationState {
  final String message;
  CalibrationSuccess(this.message);
}

class CalibrationFailure extends CalibrationState {
  final String error;
  CalibrationFailure(this.error);
}

class CalibrationBloc extends Bloc<CalibrationEvent, CalibrationState> {
  final IPlaneClient client;
  Timer? _timer;

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
      int secondsRemaining = 10;
      emit(CalibrationInProgress('Mueve el avión en todas direcciones...',
          secondsRemaining: secondsRemaining));

      try {
        await client.sendCalibrateMAG();

        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          secondsRemaining--;
          if (secondsRemaining > 0) {
            add(CalibrationTickEvent(secondsRemaining));
          } else {
            timer.cancel();
            add(CalibrationTickEvent(0));
          }
        });
      } catch (e) {
        _timer?.cancel();
        emit(CalibrationFailure('Error en calibración de magnetómetro'));
      }
    });

    on<CalibrationTickEvent>((event, emit) async {
      if (event.secondsRemaining > 0) {
        emit(CalibrationInProgress('Mueve el avión en todas direcciones...',
            secondsRemaining: event.secondsRemaining));
      } else {
        _timer?.cancel();
        emit(CalibrationSuccess('Calibración de magnetómetro completada.'));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
