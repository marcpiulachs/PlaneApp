import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_event.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_state.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/settings_category.dart';
import 'package:paperwings/models/settings_page.dart';
import 'package:paperwings/pages/sensors.dart';

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
  }

  // Maneja el evento de verificar la versión
  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<MechanicsState> emit,
  ) async {
    try {
      if (client.isConnected) {
        emit(SettingsLoadingState());
        // Define las categorías de ajustes
        final categories = [
          SettingsCategory(
            title: "General",
            pages: [
              SettingPage(
                title: "Profile",
                description: "Manage your profile settings",
                icon: Icons.person,
                page: const SensorGraphPage(),
              ),
              SettingPage(
                title: "Notifications",
                description: "Customize notification preferences",
                icon: Icons.notifications,
                page: const SensorGraphPage(),
              ),
            ],
          ),
          SettingsCategory(
            title: "System",
            pages: [
              SettingPage(
                title: "Connectivity",
                description: "Manage network and Bluetooth",
                icon: Icons.wifi,
                page: const SensorGraphPage(),
              ),
              SettingPage(
                title: "Storage",
                description: "View storage usage and settings",
                icon: Icons.storage,
                page: const SensorGraphPage(),
              ),
            ],
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
