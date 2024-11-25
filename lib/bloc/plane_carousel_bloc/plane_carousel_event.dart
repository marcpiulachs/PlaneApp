// Definir los eventos del PlaneCarouselBloc
abstract class PlaneCarouselEvent {}

class LoadPlanesEvent extends PlaneCarouselEvent {}

class PlaneSelectionChangedEvent extends PlaneCarouselEvent {
  final int selectedIndex;
  PlaneSelectionChangedEvent(this.selectedIndex);
}

class PlaneConnectionChanged extends PlaneCarouselEvent {
  final bool isConnected;

  PlaneConnectionChanged(this.isConnected);
}
