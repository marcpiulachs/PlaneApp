import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:paperwings/events/plane_selected_event.dart';
import 'package:paperwings/repositories/plane_repository.dart';
import 'package:paperwings/clients/plane_client_interface.dart';

class PlaneCarouselBloc extends Bloc<PlaneCarouselEvent, PlaneCarouselState> {
  final IPlaneClient client;
  final EventBus eventBus;
  final PlaneRepository repository;

  PlaneCarouselBloc(
      {required this.client, required this.repository, required this.eventBus})
      : super(PlaneCarouselInitial()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    client.connectedStream.listen((isConnected) {
      add(PlaneConnectionChanged(isConnected));
    });

    on<PlaneConnectionChanged>((event, emit) {
      if (state is PlaneCarouselLoaded) {
        final loadedState = state as PlaneCarouselLoaded;
        emit(loadedState.copyWith(isConnected: event.isConnected));
      }
    });

    on<LoadPlanesEvent>((event, emit) {
      final planes = repository.fetchPlanes();
      emit(PlaneCarouselLoaded(
        planes: planes,
        currentIndex: 0,
        isConnected: client.isConnected,
      ));
    });

    on<PlaneSelectionChangedEvent>((event, emit) {
      if (state is PlaneCarouselLoaded) {
        final loadedState = state as PlaneCarouselLoaded;
        emit(loadedState.copyWith(currentIndex: event.selectedIndex));
        // Notify about the new plane selection
        eventBus.fire(PlaneSelectedEvent(loadedState.selectedPlane));
      }
    });
  }
}
