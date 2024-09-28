// Estado del tab
import 'package:equatable/equatable.dart';

class HomeTabState {
  final int currentTabIndex;
  final int previousTabIndex;

  const HomeTabState({
    required this.currentTabIndex,
    required this.previousTabIndex,
  });
}
