import 'package:equatable/equatable.dart';

abstract class OtaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para verificar la versión del firmware en el ESP32
class CheckVersionEvent extends OtaEvent {
  CheckVersionEvent();
}

// Evento para iniciar la actualización del firmware
class StartUpdateEvent extends OtaEvent {}
