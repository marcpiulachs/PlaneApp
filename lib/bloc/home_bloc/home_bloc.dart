// Bloc que controla el tab activo
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_event.dart';
import 'package:paperwings/bloc/home_bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeTabState> {
  HomeBloc()
      : super(const HomeTabState(currentTabIndex: 0, previousTabIndex: 0)) {
    on<HomeTabChangedEvent>((event, emit) {
      emit(HomeTabState(
        currentTabIndex: event.tabIndex,
        previousTabIndex: state.currentTabIndex,
      ));
    });
  }
}
