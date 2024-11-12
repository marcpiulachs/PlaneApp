import 'package:equatable/equatable.dart';
import 'package:paperwings/models/settings_page.dart';

abstract class MechanicsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para verificar la versión del firmware en el ESP32
class LoadSettingsEvent extends MechanicsEvent {
  LoadSettingsEvent();
}

// Evento para iniciar la actualización del firmware
class StartUpdateEvent extends MechanicsEvent {}

class ConnectEvent extends MechanicsEvent {}

class SelectSettingsPageEvent extends MechanicsEvent {
  final SettingPage page;

  SelectSettingsPageEvent(this.page);
}
