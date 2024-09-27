import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_event.dart';
import 'package:object_3d/bloc/fly_bloc/fly_state.dart';
import 'package:object_3d/clients/plane_client_interface.dart';
import 'package:object_3d/core/flight_orientation.dart';
import 'package:object_3d/core/flight_recorder.dart';
import 'dart:developer' as developer;

class FlyBloc extends Bloc<FlyEvent, FlyState> {
  final IPlaneClient client;
  late FlightRecorder flightRecorder;
  late FlightOrientation flightOrientation;

  FlyBloc({required this.client}) : super(FlyInitialState()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    client.connectedStream.listen((isConnected) {
      add(FlyCheckConnectionEvent());
    });

    flightOrientation = FlightOrientation(
      onPitchChanged: (pitch) => add(PitchUpdated(pitch)),
      onRollChanged: (roll) => add(RollUpdated(roll)),
      onYawChanged: (yaw) => add(YawUpdated(yaw)),
      onLeftChanged: (degrees) {
        //developer.log('Inclinado hacia la izquierda: $degrees°');
      },
      onRightChanged: (degrees) {
        //developer.log('Inclinado hacia la derecha: $degrees°');
      },
      onUpChanged: (degrees) {
        //developer.log('Inclinado hacia arriba: $degrees°');
      },
      onDownChanged: (degrees) {
        //developer.log('Inclinado hacia abajo: $degrees°');
      },
      onRotateLeftChanged: (degrees) {
        //developer.log('Rotado hacia la izquierda: $degrees°');
      },
      onRotateRightChanged: (degrees) {
        //developer.log('Rotado hacia la derecha: $degrees°');
      },
    );

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
    flightRecorder = FlightRecorder(
      timerUpdated: (int seconds) {
        if (state is FlyLoadedState) {
          add(FlightRecorderUpdated());
        }
      },
      started: () {
        developer.log('FlightRecorder started');
        if (state is FlyLoadedState) {
          add(FlightRecorderUpdated());
        }
      },
      stopped: () {
        developer.log('FlightRecorder stopped');
        if (state is FlyLoadedState) {
          add(FlightRecorderUpdated());
        }
      },
      captureData: () {
        if (state is FlyLoadedState) {
          final loadedState = state as FlyLoadedState;
          add(CaptureData(loadedState.telemetry));
        }
      },
    );

    on<CaptureData>((event, emit) async {
      developer.log('Telemetry Data:');
      developer.log('GyroX: ${event.telemetry.gyroX}');
      developer.log('GyroY: ${event.telemetry.gyroY}');
      developer.log('GyroZ: ${event.telemetry.gyroZ}');
      developer.log('MagneX: ${event.telemetry.magnetometerX}');
      developer.log('MagneY: ${event.telemetry.magnetometerY}');
      developer.log('MagneZ: ${event.telemetry.magnetometerZ}');
      developer.log('Barometer: ${event.telemetry.barometer}');
      developer.log('Motor1Speed: ${event.telemetry.motor1Speed}');
      developer.log('Motor2Speed: ${event.telemetry.motor2Speed}');
      // store telemetry data
      flightRecorder.data.add(event.telemetry);
    });

    on<SendArmed>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendArmed(event.isArmed);
        final loadedState = state as FlyLoadedState;
        if (event.isArmed) {
          // flight started
          flightRecorder.start();
          flightOrientation.start();
        } else {
          // flight completed
          flightRecorder.stop();
          flightOrientation.stop();
        }
        emit(loadedState.copyWith(isArmed: event.isArmed));
      }
    });

    on<SendThrottle>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendThrottle(event.value);
        final loadedState = state as FlyLoadedState;
        emit(loadedState);
      }
    });

    // Event handlers for new events
    on<GyroXUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(gyroX: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<GyroYUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(gyroY: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<GyroZUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(gyroZ: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerXUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magnetometerX: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerYUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magnetometerY: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerZUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magnetometerZ: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<BarometerUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(barometer: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<Motor1SpeedUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(motor1Speed: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<Motor2SpeedUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(motor2Speed: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<BatteryUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(battery: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<SignalUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(signal: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<FlightRecorderUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        emit(loadedState.copyWith(
          duration: flightRecorder.duration,
          isRecording: flightRecorder.isRecording,
        ));
      }
    });

    on<YawUpdated>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendYaw(event.value);
        final loadedState = state as FlyLoadedState;
        final updatedDirection =
            loadedState.direction.copyWith(yaw: event.value);
        emit(loadedState.copyWith(direction: updatedDirection));
        developer.log('Pitch: ${loadedState.direction.pitch}');
        developer.log('Roll:  ${loadedState.direction.roll}');
        developer.log('Yaw:   ${loadedState.direction.yaw}');
      }
    });

    on<PitchUpdated>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendPitch(event.value);
        final loadedState = state as FlyLoadedState;
        final updatedDirection =
            loadedState.direction.copyWith(pitch: event.value);
        emit(loadedState.copyWith(direction: updatedDirection));
        developer.log('Pitch: ${loadedState.direction.pitch}');
        developer.log('Roll:  ${loadedState.direction.roll}');
        developer.log('Yaw:   ${loadedState.direction.yaw}');
      }
    });

    on<RollUpdated>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendRoll(event.value);
        final loadedState = state as FlyLoadedState;
        final updatedDirection =
            loadedState.direction.copyWith(roll: event.value);
        emit(loadedState.copyWith(direction: updatedDirection));
        developer.log('Pitch: ${loadedState.direction.pitch}');
        developer.log('Roll:  ${loadedState.direction.roll}');
        developer.log('Yaw:   ${loadedState.direction.yaw}');
      }
    });

    on<SendManeuver>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendManeuver(event.maneuver);
        final loadedState = state as FlyLoadedState;
        emit(loadedState);
      }
    });

    on<FlyCheckConnectionEvent>((event, emit) {
      if (!client.isConnected) {
        emit(FlyDisconnectedState());
      } else {
        emit(FlyLoadedState());
      }
    });

    add(FlyCheckConnectionEvent());
  }

  @override
  Future<void> close() {
    flightRecorder.dispose();
    flightOrientation.dispose();
    return super.close();
  }
}
