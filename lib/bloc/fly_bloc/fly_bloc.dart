import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_event.dart';
import 'package:object_3d/bloc/fly_bloc/fly_state.dart';
import 'package:object_3d/clients/plane_client_interface.dart';
import 'package:object_3d/core/flight_recorder.dart';

class FlyBloc extends Bloc<FlyEvent, FlyState> {
  final IPlaneClient client;
  final FlightRecorder flightRecorder = FlightRecorder();

  FlyBloc({required this.client}) : super(FlyInitial()) {
    // Suscripción a los callbacks del cliente
    client.onConnect = () {
      add(TcpClientConnected());
    };
    client.onDisconnect = () {
      add(TcpClientDisconnected());
    };
    client.onConnectionFailed = () {
      add(TcpClientDisconnected());
    };
    client.onGyroX = (value) {
      add(GyroXUpdated(value));
    };
    client.onGyroY = (value) {
      add(GyroYUpdated(value));
    };
    client.onGyroZ = (value) {
      add(GyroZUpdated(value));
    };
    client.onMagnetometerX = (value) {
      add(MagnetometerXUpdated(value));
    };
    client.onMagnetometerY = (value) {
      add(MagnetometerYUpdated(value));
    };
    client.onMagnetometerZ = (value) {
      add(MagnetometerZUpdated(value));
    };
    client.onBarometer = (value) {
      add(BarometerUpdated(value));
    };
    client.onMotor1Speed = (value) {
      add(Motor1SpeedUpdated(value));
    };
    client.onMotor2Speed = (value) {
      add(Motor2SpeedUpdated(value));
    };
    client.onBattery = (value) {
      add(BatteryUpdated(value));
    };
    client.onSignal = (value) {
      add(SignalUpdated(value));
    };

    // Configuración de FlightRecorder
    flightRecorder.timerUpdated = (int seconds) {
      if (state is FlyPlaneConnected) {
        add(TimerUpdated(seconds));
      }
    };
    flightRecorder.started = () {
      print('FlightRecorder started');
    };
    flightRecorder.stopped = () {
      print('FlightRecorder stopped');
    };
    flightRecorder.captureData = () {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        print('Telemetry Data:');
        print('GyroX: ${loadedState.telemetry.gyroX}');
        print('GyroY: ${loadedState.telemetry.gyroY}');
        print('GyroZ: ${loadedState.telemetry.gyroZ}');
        print('MagnetometerX: ${loadedState.telemetry.magnetometerX}');
        print('MagnetometerY: ${loadedState.telemetry.magnetometerY}');
        print('MagnetometerZ: ${loadedState.telemetry.magnetometerZ}');
        print('Barometer: ${loadedState.telemetry.barometer}');
        print('Motor1Speed: ${loadedState.telemetry.motor1Speed}');
        print('Motor2Speed: ${loadedState.telemetry.motor2Speed}');
        print('Motor1Speed: ${loadedState.telemetry.motor1Speed}');
        print('Motor2Speed: ${loadedState.telemetry.motor2Speed}');
      }
    };

    on<TcpClientConnect>((event, emit) async {
      emit(FlyConnecting());
      await Future.delayed(const Duration(seconds: 1));
      await client.connect();
    });

    on<TcpClientConnected>((event, emit) {
      emit(FlyPlaneConnected());
    });

    on<TcpClientDisconnected>((event, emit) {
      emit(FlyPlaneDisconnected());
    });

    on<SendArmed>((event, emit) async {
      await client.sendArmed(event.isArmed);
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        if (event.isArmed) {
          flightRecorder.start(); // Iniciar contador
        } else {
          flightRecorder.stop(); // Detener y reiniciar contador
        }
        emit(loadedState.copyWith(duration: flightRecorder.duration));
      }
    });

    on<SendThrottle>((event, emit) async {
      await client.sendThrottle(event.throttleValue);
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState);
      }
    });

    // Event handlers for new events
    on<GyroXUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(gyroX: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<GyroYUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(gyroY: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<GyroZUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(gyroZ: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerXUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magnetometerX: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerYUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magnetometerY: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerZUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magnetometerZ: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<BarometerUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(barometer: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<Motor1SpeedUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(motor1Speed: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<Motor2SpeedUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(motor2Speed: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<BatteryUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(battery: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<SignalUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(signal: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<TimerUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(duration: event.seconds));
      }
    });

    if (client.isConnected) {
      // Emitir FlyLoaded después de que el Bloc ha sido creado
      add(TcpClientConnected());
    } else {
      add(TcpClientDisconnected());
    }
  }

  @override
  Future<void> close() {
    flightRecorder.dispose(); // Liberar recursos del FlightRecorder
    return super.close();
  }
}
