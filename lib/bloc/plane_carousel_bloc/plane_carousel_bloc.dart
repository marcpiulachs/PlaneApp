import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:object_3d/clients/tcp_client_interface.dart';
import 'package:object_3d/models/plane_item.dart';

class PlaneCarouselBloc extends Bloc<PlaneCarouselEvent, PlaneCarouselState> {
  final ITcpClient client;

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
        ),
        PlaneItem(
          imageUrl: 'assets/planes/blue.png',
          title: 'K22 Destroyer',
          description: "Plane to win a war",
          progress1: 0.1,
          progress2: 0.7,
          progress3: 0.2,
          icon: Icons.airplane_ticket,
        ),
        PlaneItem(
          imageUrl: 'assets/planes/orange.png',
          title: 'H22',
          description: "A japanesse inspired plane",
          progress1: 0.1,
          progress2: 0.4,
          progress3: 0.9,
          icon: Icons.timer,
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
