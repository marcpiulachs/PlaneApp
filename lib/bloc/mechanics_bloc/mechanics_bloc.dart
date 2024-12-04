import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_event.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/settings_page.dart';
import 'package:paperwings/pages/beacon_settings.dart';
import 'package:paperwings/pages/log_settings.dart';
import 'package:paperwings/pages/motor_settings.dart';
import 'package:paperwings/pages/power_settings.dart';
import 'package:paperwings/pages/sensors.dart';
import 'package:paperwings/pages/flight_settings.dart';

class MechanicsBloc extends Bloc<MechanicsEvent, MechanicsState> {
  final IPlaneClient client;

  MechanicsBloc({required this.client}) : super(MechanicsInitialState()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    client.connectedStream.listen((isConnected) {
      add(LoadSettingsEvent());
    });
    on<SelectSettingsPageEvent>(_onSelectSettingsPage);
    on<LoadSettingsEvent>(_onLoadSettings);

    add(LoadSettingsEvent());

    on<BackToMainSettingsEvent>((event, emit) {
      add(LoadSettingsEvent());
    });
  }

  // Maneja el evento de verificar la versión
  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<MechanicsState> emit,
  ) async {
    try {
      if (client.isConnected) {
        emit(SettingsLoadingState());
        final categories = [
          SettingPage(
            title: "Flight Settings",
            description: "Manage your PID profile settings",
            icon: Icons.airplanemode_on,
            page: const EngineSettings(),
          ),
          SettingPage(
            title: "Sensors",
            description: "Display realtime data from sensors in your plane",
            icon: Icons.sensors,
            page: const SensorGraphPage(),
          ),
          SettingPage(
            title: "Beacon",
            description: "Setup plane position lights",
            icon: Icons.lightbulb,
            page: const BeaconSettings(),
          ),
          SettingPage(
            title: "Gyroscope Calibration",
            description: "Calibrating will help improve its accuracy",
            icon: Icons.compass_calibration,
            page: const SensorGraphPage(),
          ),
          SettingPage(
            title: "Compass Calibration",
            description: "Calibrating will help improve its accuracy",
            icon: Icons.compass_calibration,
            page: const BeaconSettings(),
          ),
          SettingPage(
            title: "Accelerometer Calibration",
            description: "Calibrating will help improve its accuracy",
            icon: Icons.compass_calibration,
            page: const BeaconSettings(),
          ),
          SettingPage(
            title: "Motors",
            description: "Test motors",
            icon: Icons.compass_calibration,
            page: const MotorSettingsScreen(),
          ),
          SettingPage(
            title: "Log",
            description: "Turns on/off serial output module logging",
            icon: Icons.compass_calibration,
            page: const LogSettings(),
          ),
          SettingPage(
            title: "Power Off",
            description: "Turns off the plane",
            icon: Icons.power,
            page: const PowerSettings(),
          ),
        ];
        emit(SettingsLoadedState(categories));
      } else {
        emit(MechanicsPlaneDisconectedState());
      }
    } on TimeoutException {
      // Manejar excepción
      emit(MechanicsErrorState("Timeout: Plane not responding"));
    } on Exception catch (e) {
      // Manejar excepción
      emit(MechanicsErrorState(e.toString()));
    }
  }

  void _onSelectSettingsPage(
    SelectSettingsPageEvent event,
    Emitter<MechanicsState> emit,
  ) {
    emit(SettingsPageSelectedState(event.page));
  }
}
