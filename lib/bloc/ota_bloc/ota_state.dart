import 'package:equatable/equatable.dart';

abstract class OtaState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Estado inicial: esperando
class OtaInitialState extends OtaState {}

class OtaGettingVersionState extends OtaState {}

class OtaPlaneDisconectedState extends OtaState {}

// Estado cuando la versión del ESP32 ha sido cargada
class OtaLoadedVersionState extends OtaState {
  final String appVersion;
  final String appFirmware;
  final String devFirmware;
  final bool updateAvailable;

  OtaLoadedVersionState(
    this.appVersion,
    this.appFirmware,
    this.devFirmware,
    this.updateAvailable,
  );

  @override
  List<Object?> get props => [devFirmware, appFirmware, updateAvailable];
}

class OtaErrorState extends OtaState {
  final String error;

  OtaErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// Estado durante la actualización
class OtaUpdatingState extends OtaState {
  final double progress;

  OtaUpdatingState(this.progress);

  @override
  List<Object?> get props => [progress];
}

// Estado final: actualización completada
class OtaUpdateCompletedState extends OtaState {
  final bool success;

  OtaUpdateCompletedState(this.success);

  @override
  List<Object?> get props => [success];
}
