import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_event.dart';
import 'package:paperwings/bloc/fly_bloc/fly_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/core/flight_orientation.dart';
import 'package:paperwings/core/flight_recorder.dart';
import 'package:paperwings/models/telemetry.dart';
import 'dart:async';
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
  late final StreamSubscription<bool> _connectedSubscription;
  late final StreamSubscription<Telemetry> _telemetrySubscription;
  late final StreamSubscription<PlaneSelectedEvent> _planeSelectedSubscription;

  FlyBloc({required this.client, required this.eventBus})
      : super(FlyInitialState()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    _connectedSubscription = client.connectedStream.listen((isConnected) {
      add(FlyCheckConnectionEvent());
    });

    _planeSelectedSubscription = eventBus.on<PlaneSelectedEvent>().listen((event) {
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

    _telemetrySubscription = client.telemetryStream.listen((telemetry) {
      add(TelemetryUpdated(telemetry));
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

    // Event handler for telemetry updates
    on<TelemetryUpdated>((event, emit) {
      if (state is FlyLoadedState) {
        emit((state as FlyLoadedState).copyWith(telemetry: event.telemetry));
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
    _connectedSubscription.cancel();
    _telemetrySubscription.cancel();
    _planeSelectedSubscription.cancel();
    return super.close();
  }
}
