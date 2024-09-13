import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_event.dart';
import 'package:object_3d/bloc/fly_bloc/fly_state.dart';

import 'package:object_3d/models/plane_item.dart';

class FlyBloc extends Bloc<FlyEvent, FlyState> {
  FlyBloc() : super(FlyInitial()) {
    on<LoadFlyEvent>((event, emit) {
      emit(FlyLoaded());
    });

    on<FlySelectedEvent>((event, emit) {
      if (state is FlyLoaded) {
        final loadedState = state as FlyLoaded;
        emit(FlyLoaded());
      }
    });
  }
}
