// Definir los eventos del PlaneCarouselBloc
abstract class FlyEvent {}

class LoadFlyEvent extends FlyEvent {}

class FlySelectedEvent extends FlyEvent {
  final int selectedIndex;
  FlySelectedEvent(this.selectedIndex);
}
