import 'package:equatable/equatable.dart';
import 'package:paperwings/models/settings_page.dart';

abstract class MechanicsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Estado inicial: esperando
class MechanicsInitialState extends MechanicsState {}

class MechanicsLoadedState extends MechanicsState {}

class MechanicsPlaneDisconectedState extends MechanicsState {}

// Estado cuando la versión del ESP32 ha sido cargada
class MechanicsLoadedVersionState extends MechanicsState {
  MechanicsLoadedVersionState();

  @override
  List<Object?> get props => [];
}

class MechanicsErrorState extends MechanicsState {
  final String error;

  MechanicsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class SettingsInitialState extends MechanicsState {}

class SettingsLoadingState extends MechanicsState {}

class SettingsLoadedState extends MechanicsState {
  final List<SettingPage> categories;

  SettingsLoadedState(this.categories);
}

class SettingsPageSelectedState extends MechanicsState {
  final SettingPage selectedPage;

  SettingsPageSelectedState(this.selectedPage);
}
