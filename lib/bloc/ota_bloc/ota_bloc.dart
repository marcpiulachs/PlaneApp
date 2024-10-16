import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/verison.dart';

import 'ota_event.dart';
import 'ota_state.dart';

class OtaBloc extends Bloc<OtaEvent, OtaState> {
  final IPlaneClient client;
  // App version
  Version appVersion = Version(1, 0, 0);
  // App firmware version
  Version devFirmwareVersion = Version(0, 0, 0);
  // Versión actual del firmware de la app
  Version appFirmwareVersion = Version(1, 2, 0);

  // Urls from device services
  final verUrl = Uri.parse('http://192.168.4.1/ver');
  final otaUrl = Uri.parse('http://192.168.4.1/ota');

  // Location of firmware in assets
  final String assetFirmware = "assets/firmware/pfw.bin";

  OtaBloc({required this.client}) : super(OtaInitialState()) {
    // Suscripción al Stream de cambios de la propiedad isConnected
    client.connectedStream.listen((isConnected) {
      add(CheckVersionEvent());
    });

    on<CheckVersionEvent>(_onCheckVersion);
    on<StartUpdateEvent>(_onStartUpdate);

    add(CheckVersionEvent());
  }

  // Maneja el evento de verificar la versión
  Future<void> _onCheckVersion(
    CheckVersionEvent event,
    Emitter<OtaState> emit,
  ) async {
    try {
      if (client.isConnected) {
        emit(OtaGettingVersionState());
        await Future.delayed(const Duration(seconds: 1));

        // Envía la solicitud
        final response = await http.get(verUrl).timeout(
              const Duration(seconds: 2),
            );

        if (response.statusCode == 200) {
          devFirmwareVersion = Version.fromString(response.body);

          emit(OtaLoadedVersionState(
            appVersion,
            appFirmwareVersion,
            devFirmwareVersion,
          ));
        } else {
          emit(
              OtaErrorState("Could not retrieve version from connected plane"));
        }
      } else {
        emit(OtaPlaneDisconectedState());
      }
    } on TimeoutException {
      // Manejar excepción
      emit(OtaErrorState("Timeout: Plane not responding"));
    } on Exception catch (e) {
      // Manejar excepción
      emit(OtaErrorState(e.toString()));
    }
  }

  // Maneja el evento de comenzar la actualización
  Future<void> _onStartUpdate(
    StartUpdateEvent event,
    Emitter<OtaState> emit,
  ) async {
    emit(OtaUpdatingState(0.0));

    // Carga el firmware desde assets
    var firmware = await rootBundle.load(assetFirmware);
    var firmwareFile = firmware.buffer.asUint8List();

    if (firmwareFile.isEmpty || firmwareFile.first != 0xE9) {
      emit(OtaUpdateCompletedState(false));
    }

    try {
      // Configura la solicitud con headers para una carga binaria
      var request = http.Request('POST', otaUrl)
        ..bodyBytes = firmwareFile
        ..headers.addAll({
          'Content-Type': 'application/octet-stream',
          'Content-Length': firmwareFile.length.toString(),
        });

      // Envía la solicitud y monitorea el progreso
      var streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
          );

      if (streamedResponse.statusCode == 200) {
        // Actualización completada con éxito
        emit(OtaUpdateCompletedState(true));
      } else {
        // Fallo en la actualización
        emit(OtaUpdateCompletedState(false));
      }
    } catch (e) {
      // Fallo en la actualización
      emit(OtaUpdateCompletedState(false));
    }
  }
}
