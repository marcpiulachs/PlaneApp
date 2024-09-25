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
class OtaVersionState extends OtaState {
  final String devFirmware;
  final String appFirmware;
  final bool updateAvailable;

  OtaVersionState(
    this.devFirmware,
    this.appFirmware,
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
