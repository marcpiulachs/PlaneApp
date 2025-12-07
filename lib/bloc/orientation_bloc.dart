import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paperwings/clients/plane_client_interface.dart';

part 'orientation_event.dart';
part 'orientation_state.dart';

class OrientationBloc extends Bloc<OrientationEvent, OrientationState> {
  final IPlaneClient client;
  OrientationBloc({required this.client}) : super(const OrientationState()) {
    on<OrientationStart>(_onStart);
    on<OrientationYawChanged>(_onYawChanged);
    on<OrientationPitchChanged>(_onPitchChanged);
    on<OrientationRollChanged>(_onRollChanged);
  }

  void _onStart(OrientationStart event, Emitter<OrientationState> emit) {
    client.onYaw.listen((yaw) {
      add(OrientationYawChanged(yaw));
    });
    client.onPitch.listen((pitch) {
      add(OrientationPitchChanged(pitch));
    });
    client.onRoll.listen((roll) {
      add(OrientationRollChanged(roll));
    });
  }

  void _onYawChanged(
      OrientationYawChanged event, Emitter<OrientationState> emit) {
    emit(state.copyWith(yaw: event.yaw));
  }

  void _onPitchChanged(
      OrientationPitchChanged event, Emitter<OrientationState> emit) {
    emit(state.copyWith(pitch: event.pitch));
  }

  void _onRollChanged(
      OrientationRollChanged event, Emitter<OrientationState> emit) {
    emit(state.copyWith(roll: event.roll));
  }
}
