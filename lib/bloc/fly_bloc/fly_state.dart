// Definir el estado del PlaneCarouselBloc
import 'package:object_3d/models/plane_item.dart';

abstract class FlyState {}

class FlyInitial extends FlyState {}

class FlyLoaded extends FlyState {
  FlyLoaded();
}

class FlyLoadedLoadFailed extends FlyState {
  final String errorMessage;
  FlyLoadedLoadFailed(this.errorMessage);
}
