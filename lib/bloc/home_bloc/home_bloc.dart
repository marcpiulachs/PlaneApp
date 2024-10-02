// Bloc que controla el tab activo
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_event.dart';
import 'package:paperwings/bloc/home_bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeLoadedState> {
  HomeBloc() : super(HomeLoadedState(currentTabIndex: 0, previousTabIndex: 0)) {
    on<HomeTabChangedEvent>((event, emit) {
      emit(HomeLoadedState(
        currentTabIndex: event.selectedTabIndex,
        previousTabIndex: state.currentTabIndex,
      ));
    });
  }
}
