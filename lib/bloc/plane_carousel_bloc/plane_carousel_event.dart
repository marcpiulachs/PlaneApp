// Definir los eventos del PlaneCarouselBloc
abstract class PlaneCarouselEvent {}

class LoadPlanesEvent extends PlaneCarouselEvent {}

class PlaneSelectedEvent extends PlaneCarouselEvent {
  final int selectedIndex;
  PlaneSelectedEvent(this.selectedIndex);
}
