import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_event.dart';
import 'package:paperwings/bloc/fly_bloc/fly_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/core/flight_orientation.dart';
import 'package:paperwings/core/flight_recorder.dart';
import 'dart:developer' as developer;
import 'package:paperwings/events/plane_selected_event.dart';

class UpdateWifiSignalEvent extends FlyEvent {
  final int signal;
  UpdateWifiSignalEvent(this.signal);
}

class FlyBloc extends Bloc<FlyEvent, FlyState> {
  // ...resto de la clase...
  final IPlaneClient client;
  final EventBus eventBus;
  late FlightRecorder flightRecorder;
  late FlightOrientation flightOrientation;

  FlyBloc({required this.client, required this.eventBus})
      : super(FlyInitialState()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    client.connectedStream.listen((isConnected) {
      add(FlyCheckConnectionEvent());
    });

    eventBus.on<PlaneSelectedEvent>().listen((event) {
      developer.log('Plane selected : ${event.plane.title}');
    });

    flightOrientation = FlightOrientation(
      onPitchChanged: (pitch) => {
        //developer.log('Inclinado hacia la izquierda: $degrees°');
      },
      onRollChanged: (roll) => {
        add(SendYoke(roll)),
        developer.log('Inclinado : $roll'),
      },
      onYawChanged: (yaw) => {
        //developer.log('Inclinado hacia la izquierda: $degrees°');
      },
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

    client.onGyroX.listen((value) {
      add(GyroXUpdated(value));
    });
    client.onGyroY.listen((value) {
      add(GyroYUpdated(value));
    });
    client.onGyroZ.listen((value) {
      add(GyroZUpdated(value));
    });
    client.onMagnetometerX.listen((value) {
      add(MagnetometerXUpdated(value));
    });
    client.onMagnetometerY.listen((value) {
      add(MagnetometerYUpdated(value));
    });
    client.onMagnetometerZ.listen((value) {
      add(MagnetometerZUpdated(value));
    });
    client.onBarometer.listen((value) {
      add(BarometerUpdated(value));
    });
    client.onMotor1Speed.listen((value) {
      add(Motor1SpeedUpdated(value));
    });
    client.onMotor2Speed.listen((value) {
      add(Motor2SpeedUpdated(value));
    });
    client.onBatterySoc.listen((value) {
      add(BatterySocUpdated(value));
    });
    client.onBatteryVol.listen((value) {
      add(BatteryVolUpdated(value));
    });
    client.onSignal.listen((value) {
      add(SignalUpdated(value));
    });
    client.onAccelerometerX.listen((value) {
      add(AccelerometerXUpdated(value));
    });
    client.onAccelerometerY.listen((value) {
      add(AccelerometerYUpdated(value));
    });
    client.onAccelerometerZ.listen((value) {
      add(AccelerometerZUpdated(value));
    });
    client.onPitch.listen((value) {
      add(PitchUpdated(value));
    });
    client.onRoll.listen((value) {
      add(RollUpdated(value));
    });
    client.onYaw.listen((value) {
      add(YawUpdated(value));
    });

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
          add(CaptureData(FlightData(
            telemetry: loadedState.telemetry,
            userAction: loadedState.userAction,
          )));
        }
      },
    );

    // ...existing code...
    on<ManeuverSelectedEvent>((event, emit) async {
      if (state is FlyLoadedState) {
        // Mapear el tipo de maniobra al comando del firmware
        await client.sendManeuver(event.maneuverType.value);
        // No cambiamos el estado, fire and forget
      }
    });

    on<UpdateWifiSignalEvent>((event, emit) {
      if (state is FlyLoadedState) {
        emit((state as FlyLoadedState).copyWith(wifiSignal: event.signal));
      }
    });

    on<CaptureData>((event, emit) async {
      developer.log('Telemetry Data:');
      developer.log('GyroX: ${event.flightData.telemetry.gyroX}');
      developer.log('GyroY: ${event.flightData.telemetry.gyroY}');
      developer.log('GyroZ: ${event.flightData.telemetry.gyroZ}');
      developer.log('MagneX: ${event.flightData.telemetry.magX}');
      developer.log('MagneY: ${event.flightData.telemetry.magY}');
      developer.log('MagneZ: ${event.flightData.telemetry.magZ}');
      developer.log('Motor1Speed: ${event.flightData.telemetry.motor1Speed}');
      developer.log('Motor2Speed: ${event.flightData.telemetry.motor2Speed}');
      developer.log('AccelX: ${event.flightData.telemetry.accelX}');
      developer.log('AccelY: ${event.flightData.telemetry.accelY}');
      developer.log('AccelZ: ${event.flightData.telemetry.accelZ}');
      developer.log('Yoke: ${event.flightData.userAction.yoke}');
      developer.log('Throttle: ${event.flightData.userAction.throttle}');

      // store telemetry data
      flightRecorder.data.add(event.flightData);
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

    on<SendYoke>((event, emit) async {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        await client.sendYoke(event.value);
        final updatedAction =
            loadedState.userAction.copyWith(yoke: event.value);
        emit(loadedState.copyWith(
          userAction: updatedAction,
        ));
      }
    });

    on<SendThrottle>((event, emit) async {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        await client.sendThrottle(event.value);
        final updatedAction =
            loadedState.userAction.copyWith(throttle: event.value);
        emit(loadedState.copyWith(
          userAction: updatedAction,
        ));
      }
    });

    on<SendManeuver>((event, emit) async {
      if (state is FlyLoadedState) {
        await client.sendManeuver(event.maneuver);
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
            loadedState.telemetry.copyWith(magX: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerYUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magY: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<MagnetometerZUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(magZ: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<AccelerometerXUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(accelX: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<AccelerometerYUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(accelY: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<AccelerometerZUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(accelZ: event.value);
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

    on<BatterySocUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(batterySoc: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<BatteryVolUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(batteryVol: event.value);
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

    on<PitchUpdated>((event, emit) async {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(pitch: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<RollUpdated>((event, emit) async {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(roll: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
      }
    });

    on<YawUpdated>((event, emit) async {
      if (state is FlyLoadedState) {
        final loadedState = state as FlyLoadedState;
        final updatedTelemetry =
            loadedState.telemetry.copyWith(yaw: event.value);
        emit(loadedState.copyWith(telemetry: updatedTelemetry));
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

  Future<void> updateWifiSignal() async {
    try {
      add(UpdateWifiSignalEvent(0));
    } catch (e) {
      // Error al obtener señal WiFi
      add(UpdateWifiSignalEvent(0));
    }
  }

  @override
  Future<void> close() {
    flightRecorder.dispose();
    flightOrientation.dispose();
    return super.close();
  }
}
