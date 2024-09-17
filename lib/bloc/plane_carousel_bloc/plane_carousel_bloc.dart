import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:object_3d/clients/plane_client_interface.dart';
import 'package:object_3d/core/flight_settings.dart';
import 'package:object_3d/models/plane_item.dart';

class PlaneCarouselBloc extends Bloc<PlaneCarouselEvent, PlaneCarouselState> {
  final IPlaneClient client;

  PlaneCarouselBloc({required this.client}) : super(PlaneCarouselInitial()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    client.connectedStream.listen((isConnected) {
      add(FlyConnectionChanged(isConnected));
    });

    on<FlyConnectionChanged>((event, emit) {
      if (state is PlaneCarouselLoaded) {
        final loadedState = state as PlaneCarouselLoaded;
        emit(loadedState.copyWith(isConnected: event.isConnected));
      }
    });

    on<LoadPlanesEvent>((event, emit) {
      final planeItems = [
        PlaneItem(
          imageUrl: 'assets/planes/black.png',
          title: 'Paper Monster',
          description: "A japanesse inspired plane",
          progress1: 0.3,
          progress2: 0.9,
          progress3: 0.4,
          icon: Icons.support,
          settings: FlightSettings(
            steeringAngle: 15.0,
            pitchKp: 1.2,
            pitchRateKp: 0.8,
            rollKp: 1.5,
            rollRateKp: 1.0,
            yawKp: 2.0,
            yawRateKp: 1.3,
            angleOfAttack: 5.0,
          ),
        ),
        PlaneItem(
          imageUrl: 'assets/planes/blue.png',
          title: 'K22 Destroyer',
          description: "Plane to win a war",
          progress1: 0.1,
          progress2: 0.7,
          progress3: 0.2,
          icon: Icons.airplane_ticket,
          settings: FlightSettings(
            steeringAngle: 30.0,
            pitchKp: 0.9,
            pitchRateKp: 1.1,
            rollKp: 1.3,
            rollRateKp: 1.2,
            yawKp: 1.8,
            yawRateKp: 1.0,
            angleOfAttack: 7.5,
          ),
        ),
        PlaneItem(
          imageUrl: 'assets/planes/orange.png',
          title: 'H22',
          description: "A japanesse inspired plane",
          progress1: 0.1,
          progress2: 0.4,
          progress3: 0.9,
          icon: Icons.timer,
          settings: FlightSettings(
            steeringAngle: 10.0,
            pitchKp: 1.5,
            pitchRateKp: 0.7,
            rollKp: 1.2,
            rollRateKp: 0.9,
            yawKp: 1.9,
            yawRateKp: 1.2,
            angleOfAttack: 6.0,
          ),
        ),
      ];

      emit(PlaneCarouselLoaded(
        planeItems: planeItems,
        selectedPlane: planeItems[0],
        currentIndex: 0,
        isConnected: client.isConnected,
      ));

      //client.connect();
    });

    on<PlaneSelectedEvent>((event, emit) {
      if (state is PlaneCarouselLoaded) {
        final loadedState = state as PlaneCarouselLoaded;
        emit(PlaneCarouselLoaded(
          planeItems: loadedState.planeItems,
          selectedPlane: loadedState.planeItems[event.selectedIndex],
          currentIndex: event.selectedIndex,
          isConnected: client.isConnected,
        ));
      }
    });
  }
}
