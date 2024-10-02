// Estado del tab
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class HomeLoadedState extends HomeState {
  final int currentTabIndex;
  final int previousTabIndex;

  HomeLoadedState({
    required this.currentTabIndex,
    required this.previousTabIndex,
  });

  @override
  List<Object> get props => [currentTabIndex, previousTabIndex];
}
