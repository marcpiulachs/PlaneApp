import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/sensor_data.dart';
import 'package:paperwings/models/telemetry.dart';

// Bloc para manejar el estado
class SensorBloc extends Cubit<SensorState> {
  final IPlaneClient client;
  late final StreamSubscription<Telemetry> _telemetrySubscription;
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
    _telemetrySubscription = client.telemetryStream.listen((telemetry) {
      emit(state.copyWith(
        gyroscopeX: telemetry.gyroX,
        gyroscopeY: telemetry.gyroY,
        gyroscopeZ: telemetry.gyroZ,
        accelerometerX: telemetry.accelX,
        accelerometerY: telemetry.accelY,
        accelerometerZ: telemetry.accelZ,
        magnamometerX: telemetry.magX,
        magnamometerY: telemetry.magY,
        magnamometerZ: telemetry.magZ,
      ));
    });
  }

  @override
  Future<void> close() {
    _telemetrySubscription.cancel();
    return super.close();
  }
}