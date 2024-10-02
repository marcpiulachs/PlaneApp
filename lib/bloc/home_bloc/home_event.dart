// Evento para cambiar el tab
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeTabChangedEvent extends HomeEvent {
  final int selectedTabIndex;

  const HomeTabChangedEvent(this.selectedTabIndex);

  @override
  List<Object> get props => [selectedTabIndex];
}
