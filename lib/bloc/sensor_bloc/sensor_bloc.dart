import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/sensor_data.dart';

// Bloc para manejar el estado
class SensorBloc extends Cubit<SensorState> {
  final IPlaneClient client;
  SensorBloc({required this.client})
      : super(
          const SensorState(
            gyroscopeX: 0.0,
            gyroscopeY: 0.0,
            gyroscopeZ: 0.0,
            accelerometerX: 0.0,
            accelerometerY: 0.0,
            accelerometerZ: 0.0,
            magnamometerX: 0.0,
            magnamometerY: 0.0,
            magnamometerZ: 0.0,
          ),
        ) {
    client.onGyroX.listen((value) {
      updateGyroscopeX(value);
    });
    client.onGyroY.listen((value) {
      updateGyroscopeY(value);
    });
    client.onGyroZ.listen((value) {
      updateGyroscopeZ(value);
    });
    client.onAccelerometerX.listen((value) {
      updateAccelerometerX(value);
    });
    client.onAccelerometerY.listen((value) {
      updateAccelerometerY(value);
    });
    client.onAccelerometerZ.listen((value) {
      updateAccelerometerZ(value);
    });
    client.onMagnetometerX.listen((value) {
      updateMagnetometerX(value);
    });
    client.onMagnetometerY.listen((value) {
      updateMagnetometerY(value);
    });
    client.onMagnetometerZ.listen((value) {
      updateMagnetometerZ(value);
    });
  }

  // Métodos para actualizar los valores del giroscopio
  void updateGyroscopeX(double value) {
    emit(state.copyWith(gyroscopeX: value));
  }

  void updateGyroscopeY(double value) {
    emit(state.copyWith(gyroscopeY: value));
  }

  void updateGyroscopeZ(double value) {
    emit(state.copyWith(gyroscopeZ: value));
  }

  // Métodos para actualizar los valores del acelerómetro
  void updateAccelerometerX(double value) {
    emit(state.copyWith(accelerometerX: value));
  }

  void updateAccelerometerY(double value) {
    emit(state.copyWith(accelerometerY: value));
  }

  void updateAccelerometerZ(double value) {
    emit(state.copyWith(accelerometerZ: value));
  }

  // Métodos para actualizar los valores del magnamometro
  void updateMagnetometerX(double value) {
    emit(state.copyWith(magnamometerX: value));
  }

  void updateMagnetometerY(double value) {
    emit(state.copyWith(magnamometerY: value));
  }

  void updateMagnetometerZ(double value) {
    emit(state.copyWith(magnamometerZ: value));
  }
}
