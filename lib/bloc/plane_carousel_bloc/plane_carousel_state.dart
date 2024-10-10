// Definir el estado del PlaneCarouselBloc
import 'package:paperwings/models/plane_item.dart';
import 'package:equatable/equatable.dart';

abstract class PlaneCarouselState extends Equatable {}

class PlaneCarouselInitial extends PlaneCarouselState {
  @override
  List<Object> get props => [];
}

class PlaneCarouselLoaded extends PlaneCarouselState {
  final List<PlaneItem> planes;
  final int currentIndex;
  final bool isConnected;

  PlaneCarouselLoaded({
    required this.planes,
    required this.currentIndex,
    required this.isConnected,
  });

  // Método copyWith
  PlaneCarouselLoaded copyWith({
    List<PlaneItem>? planes,
    int? currentIndex,
    bool? isConnected,
  }) {
    return PlaneCarouselLoaded(
      planes: planes ?? this.planes,
      currentIndex: currentIndex ?? this.currentIndex,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  PlaneItem get selectedPlane => planes[currentIndex];

  @override
  List<Object?> get props => [planes, selectedPlane, currentIndex, isConnected];
}

class PlaneCarouselLoadFailed extends PlaneCarouselState {
  final String errorMessage;
  PlaneCarouselLoadFailed(this.errorMessage);
  @override
  List<Object> get props => [];
}
