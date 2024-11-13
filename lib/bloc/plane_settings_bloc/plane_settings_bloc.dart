import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/plane_flight_settings.dart';
import 'package:paperwings/models/plane_log_settings.dart';

class PlaneSettingsBloc extends Bloc<PlaneSettingsEvent, PlaneSettingsState> {
  final IPlaneClient client;
  PlaneSettingsBloc({required this.client})
      : super(
          PlaneSettingsState(
            logSettings: PlaneLogSettings(
              imu: false,
              thrust: false,
              battery: false,
              motor: false,
            ),
            flightSettings: PlaneFlightSettings(
              steeringAngle: 5,
              pitchKp: 1.0,
              pitchRateKp: 0.5,
              rollKp: 0.5,
              rollRateKp: 0.2,
              yawKp: 0.5,
              yawRateKp: 0.2,
              angleOfAttack: 0.0,
              beacon: 0,
            ),
          ),
        ) {
    on<ResetFactorySettings>((event, emit) {
      emit(
        state.copyWith(
          flightSettings: PlaneFlightSettings(
            steeringAngle: 5,
            pitchKp: 1.0,
            pitchRateKp: 0.5,
            rollKp: 0.5,
            rollRateKp: 0.2,
            yawKp: 0.5,
            yawRateKp: 0.2,
            angleOfAttack: 0.0,
            beacon: 0,
          ),
        ),
      );
    });

    on<ShutdownEvent>((event, emit) {
      client.sendShutdown();
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(),
      ));
    });

    on<RebootEvent>((event, emit) {
      client.sendShutdown();
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(),
      ));
    });

    on<UpdateBeacon>((event, emit) {
      client.sendBeacon(event.value);
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(beacon: event.value),
      ));
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

    on<UpdateIMULogEvent>((event, emit) {
      emit(state.copyWith(
        logSettings: state.logSettings.copyWith(imu: event.value),
      ));
    });

    on<UpdateBatteryLogEvent>((event, emit) {
      emit(state.copyWith(
        logSettings: state.logSettings.copyWith(battery: event.value),
      ));
    });

    on<UpdateMotorLogEvent>((event, emit) {
      emit(state.copyWith(
        logSettings: state.logSettings.copyWith(motor: event.value),
      ));
    });

    on<UpdateThrustLogEvent>((event, emit) {
      emit(state.copyWith(
        logSettings: state.logSettings.copyWith(thrust: event.value),
      ));
    });
  }
}
