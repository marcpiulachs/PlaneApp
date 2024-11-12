import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/flight_settings_bloc/fligh_settings_event.dart';
import 'package:paperwings/bloc/flight_settings_bloc/fligh_settings_state.dart';
import 'package:paperwings/models/flight_settings.dart';

class FlightSettingsBloc
    extends Bloc<FlightSettingsEvent, FlightSettingsState> {
  FlightSettingsBloc()
      : super(
          FlightSettingsState(
            flightSettings: FlightSettings(
              steeringAngle: 5,
              pitchKp: 1.0,
              pitchRateKp: 0.5,
              rollKp: 0.5,
              rollRateKp: 0.2,
              yawKp: 0.5,
              yawRateKp: 0.2,
              angleOfAttack: 0.0,
            ),
          ),
        ) {
    on<ResetFactorySettings>((event, emit) {
      emit(
        state.copyWith(
          flightSettings: FlightSettings(
            steeringAngle: 5,
            pitchKp: 1.0,
            pitchRateKp: 0.5,
            rollKp: 0.5,
            rollRateKp: 0.2,
            yawKp: 0.5,
            yawRateKp: 0.2,
            angleOfAttack: 0.0,
          ),
        ),
      );
    });

    on<UpdateSteeringAngle>((event, emit) {
      emit(state.copyWith(
        flightSettings:
            state.flightSettings.copyWith(steeringAngle: event.value),
      ));
    });

    on<UpdatePitchKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(pitchKp: event.value),
      ));
    });

    on<UpdateRollKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(rollKp: event.value),
      ));
    });

    on<UpdateYawKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(yawKp: event.value),
      ));
    });

    on<UpdatePitchRateKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(pitchRateKp: event.value),
      ));
    });

    on<UpdateRollRateKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(rollRateKp: event.value),
      ));
    });

    on<UpdateYawRateKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(yawRateKp: event.value),
      ));
    });

    on<UpdateAngleOfAttack>((event, emit) {
      emit(state.copyWith(
        flightSettings:
            state.flightSettings.copyWith(angleOfAttack: event.value),
      ));
    });
  }
}
