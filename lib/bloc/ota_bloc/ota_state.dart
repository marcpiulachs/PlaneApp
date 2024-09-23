import 'package:equatable/equatable.dart';

abstract class OtaState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Estado inicial: esperando
class OtaInitialState extends OtaState {}

// Estado cuando la versión del ESP32 ha sido cargada
class VersionCheckedState extends OtaState {
  final String devFirmware;
  final String appFirmware;
  final bool updateAvailable;

  VersionCheckedState(
    this.devFirmware,
    this.appFirmware,
    this.updateAvailable,
  );

  @override
  List<Object?> get props => [devFirmware, updateAvailable];
}

class VersionErrorState extends OtaState {
  final String error;

  VersionErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// Estado durante la actualización
class UpdatingState extends OtaState {
  final double progress;

  UpdatingState(this.progress);

  @override
  List<Object?> get props => [progress];
}

// Estado final: actualización completada
class UpdateCompletedState extends OtaState {
  final bool success;

  UpdateCompletedState(this.success);

  @override
  List<Object?> get props => [success];
}
