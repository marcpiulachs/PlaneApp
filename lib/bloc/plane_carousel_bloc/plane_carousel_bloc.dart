import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_event.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_state.dart';
import 'package:paperwings/repositories/plane_repository.dart';
import 'package:paperwings/clients/plane_client_interface.dart';

class PlaneCarouselBloc extends Bloc<PlaneCarouselEvent, PlaneCarouselState> {
  final IPlaneClient client;
  final PlaneRepository repository;

  PlaneCarouselBloc({required this.client, required this.repository})
      : super(PlaneCarouselInitial()) {
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
      final planes = repository.fetchPlanes();
      emit(PlaneCarouselLoaded(
        planes: planes,
        currentIndex: 0,
        isConnected: client.isConnected,
      ));
    });

    on<PlaneSelectedEvent>((event, emit) {
      if (state is PlaneCarouselLoaded) {
        final loadedState = state as PlaneCarouselLoaded;
        emit(loadedState.copyWith(currentIndex: event.selectedIndex));
      }
    });
  }
}
