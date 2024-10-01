// Definir el estado del PlaneCarouselBloc
import 'package:paperwings/models/plane_item.dart';
import 'package:equatable/equatable.dart';

abstract class PlaneCarouselState extends Equatable {}

class PlaneCarouselInitial extends PlaneCarouselState {
  @override
  List<Object> get props => [];
}

class PlaneCarouselLoaded extends PlaneCarouselState {
  final List<PlaneItem> planeItems;
  final PlaneItem selectedPlane;
  final int currentIndex;
  final bool isConnected;

  PlaneCarouselLoaded({
    required this.planeItems,
    required this.selectedPlane,
    required this.currentIndex,
    required this.isConnected,
  });

  // Método copyWith
  PlaneCarouselLoaded copyWith({
    List<PlaneItem>? planeItems,
    PlaneItem? selectedPlane,
    int? currentIndex,
    bool? isConnected,
  }) {
    return PlaneCarouselLoaded(
      planeItems: planeItems ?? this.planeItems,
      selectedPlane: selectedPlane ?? this.selectedPlane,
      currentIndex: currentIndex ?? this.currentIndex,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props =>
      [planeItems, selectedPlane, currentIndex, isConnected];
}

class PlaneCarouselLoadFailed extends PlaneCarouselState {
  final String errorMessage;
  PlaneCarouselLoadFailed(this.errorMessage);
  @override
  List<Object> get props => [];
}
