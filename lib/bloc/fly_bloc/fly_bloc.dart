import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_event.dart';
import 'package:object_3d/bloc/fly_bloc/fly_state.dart';
import 'package:object_3d/clients/tcp_client.dart';
import 'package:object_3d/clients/tcp_client_interface.dart';

import 'package:object_3d/models/plane_item.dart';

class FlyBloc extends Bloc<FlyEvent, FlyState> {
  final ITcpClient client;

  FlyBloc({required this.client}) : super(FlyInitial()) {
    // Suscripción a los callbacks del cliente
    client.onConnect = () {
      add(TcpClientConnected());
    };
    client.onDisconnect = () {
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

    on<TcpClientConnect>((event, emit) async {
      emit(FlyConnecting());
      await client.connect();
    });

    on<TcpClientConnected>((event, emit) {
      /*
      if (state is FlyConnecting) {
        emit(FlyPlaneConnected());
      } else if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState);
      }*/
      emit(FlyPlaneConnected());
    });

    on<TcpClientDisconnected>((event, emit) {
      emit(FlyPlaneDisconnected());
    });

    on<SendArmed>((event, emit) async {
      await client.sendArmed(event.isArmed);
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState);
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
        emit(loadedState.copyWith(gyroX: event.value));
      }
    });

    on<GyroYUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(gyroY: event.value));
      }
    });

    on<GyroZUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(gyroZ: event.value));
      }
    });

    on<MagnetometerXUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(magnetometerX: event.value));
      }
    });

    on<MagnetometerYUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(magnetometerY: event.value));
      }
    });

    on<MagnetometerZUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(magnetometerZ: event.value));
      }
    });

    on<BarometerUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(barometer: event.value));
      }
    });

    on<Motor1SpeedUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(motor1Speed: event.value));
      }
    });

    on<Motor2SpeedUpdated>((event, emit) {
      if (state is FlyPlaneConnected) {
        final loadedState = state as FlyPlaneConnected;
        emit(loadedState.copyWith(motor2Speed: event.value));
      }
    });

    if (client.isConnected) {
      // Emitir FlyLoaded después de que el Bloc ha sido creado
      add(TcpClientConnected());
    } else {
      add(TcpClientDisconnected());
    }
  }
}
