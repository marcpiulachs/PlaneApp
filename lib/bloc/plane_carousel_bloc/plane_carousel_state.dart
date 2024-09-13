// Definir el estado del PlaneCarouselBloc
import 'package:object_3d/models/plane_item.dart';

abstract class PlaneCarouselState {}

class PlaneCarouselInitial extends PlaneCarouselState {}

class PlaneCarouselLoaded extends PlaneCarouselState {
  final List<PlaneItem> planeItems;
  final PlaneItem selectedPlane;
  final int currentIndex;

  PlaneCarouselLoaded({
    required this.planeItems,
    required this.selectedPlane,
    required this.currentIndex,
  });
}

class PlaneCarouselLoadFailed extends PlaneCarouselState {
  final String errorMessage;
  PlaneCarouselLoadFailed(this.errorMessage);
}
