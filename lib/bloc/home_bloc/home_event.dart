// Evento para cambiar el tab
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeTabChangedEvent extends HomeEvent {
  final int tabIndex;

  const HomeTabChangedEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
