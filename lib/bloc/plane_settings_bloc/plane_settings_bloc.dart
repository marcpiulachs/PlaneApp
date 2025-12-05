import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_event.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/events/plane_selected_event.dart';
import 'package:paperwings/models/plane_flight_settings.dart';
import 'package:paperwings/models/plane_log_settings.dart';

class PlaneSettingsBloc extends Bloc<PlaneSettingsEvent, PlaneSettingsState> {
  final IPlaneClient client;
  final EventBus eventBus;
  PlaneSettingsBloc({required this.client, required this.eventBus})
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
              pitchKi: 0.1,
              pitchKd: 0.05,
              rollKp: 0.5,
              rollKi: 0.05,
              rollKd: 0.02,
              yawKp: 0.5,
              yawKi: 0.05,
              yawKd: 0.02,
              angleOfAttack: 0.0,
              beacon: 0,
            ),
          ),
        ) {
    eventBus.on<PlaneSelectedEvent>().listen((event) {
      UpdateYawKp(event.plane.customSettings.yawKp);
    });

    on<ResetFactorySettings>((event, emit) {
      emit(
        state.copyWith(
          flightSettings: PlaneFlightSettings(
            steeringAngle: 5,
            pitchKp: 1.0,
            pitchKi: 0.1,
            pitchKd: 0.05,
            rollKp: 0.5,
            rollKi: 0.05,
            rollKd: 0.02,
            yawKp: 0.5,
            yawKi: 0.05,
            yawKd: 0.02,
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

    on<UpdatePitchKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(pitchKp: event.value),
      ));
    });

    on<UpdatePitchKi>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(pitchKi: event.value),
      ));
    });

    on<UpdatePitchKd>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(pitchKd: event.value),
      ));
    });

    on<UpdateRollKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(rollKp: event.value),
      ));
    });

    on<UpdateRollKi>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(rollKi: event.value),
      ));
    });

    on<UpdateRollKd>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(rollKd: event.value),
      ));
    });

    on<UpdateYawKp>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(yawKp: event.value),
      ));
    });

    on<UpdateYawKi>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(yawKi: event.value),
      ));
    });

    on<UpdateYawKd>((event, emit) {
      emit(state.copyWith(
        flightSettings: state.flightSettings.copyWith(yawKd: event.value),
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

    on<CommitAllPidSettings>((event, emit) {
      final fs = state.flightSettings;
      client.sendPitchKp(fs.pitchKp);
      client.sendPitchKi(fs.pitchKi);
      client.sendPitchKd(fs.pitchKd);
      client.sendRollKp(fs.rollKp);
      client.sendRollKi(fs.rollKi);
      client.sendRollKd(fs.rollKd);
      client.sendYawKp(fs.yawKp);
      client.sendYawKi(fs.yawKi);
      client.sendYawKd(fs.yawKd);
      // No cambiamos el estado, solo enviamos los valores actuales
    });
  }
}
