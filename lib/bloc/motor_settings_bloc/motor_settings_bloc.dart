import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paperwings/clients/plane_client_interface.dart';

part 'motor_settings_event.dart';
part 'motor_settings_state.dart';

class MotorSettingsBloc extends Bloc<MotorSettingsEvent, MotorSettingsState> {
  final IPlaneClient client;
  MotorSettingsBloc({required this.client})
      : super(const MotorSettingsState(
          isArmed: false,
          slider1Value: 0,
          slider2Value: 0,
          motor1Value: 0,
          motor2Value: 0,
        )) {
    client.onMotor1Speed.listen((value) {
      add(Motor1SpeedUpdated(value));
    });
    client.onMotor2Speed.listen((value) {
      add(Motor2SpeedUpdated(value));
    });

    on<ToggleArmedState>((event, emit) {
      final newState = state.isArmed
          ? state.copyWith(
              isArmed: false,
              slider1Value: 0,
              slider2Value: 0,
              motor1Value: 0,
              motor2Value: 0,
            )
          : state.copyWith(isArmed: true);

      client.sendArmed(newState.isArmed);
      emit(newState);
    });

    on<Slider1Changed>((event, emit) {
      emit(state.copyWith(slider1Value: event.value));
    });
    on<Slider2Changed>((event, emit) {
      emit(state.copyWith(slider2Value: event.value));
    });
    on<Motor1SpeedUpdated>((event, emit) {
      emit(state.copyWith(motor1Value: event.value));
    });
    on<Motor2SpeedUpdated>((event, emit) {
      emit(state.copyWith(motor2Value: event.value));
    });
  }
}
