import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/core/flight_settings.dart';
import 'package:paperwings/models/plane_item.dart';

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
            steeringAngle: 110,
            pitchKp: 1.5,
            pitchRateKp: 0.5,
            rollKp: 0.3,
            rollRateKp: 0.05,
            yawKp: 0.5,
            yawRateKp: 0.5,
            angleOfAttack: 5,
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
            steeringAngle: 110,
            pitchKp: 1.5,
            pitchRateKp: 0.5,
            rollKp: 0.3,
            rollRateKp: 0.05,
            yawKp: 0.5,
            yawRateKp: 0.5,
            angleOfAttack: 5,
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
            steeringAngle: 110,
            pitchKp: 1.5,
            pitchRateKp: 0.5,
            rollKp: 0.3,
            rollRateKp: 0.05,
            yawKp: 0.5,
            yawRateKp: 0.5,
            angleOfAttack: 5,
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
