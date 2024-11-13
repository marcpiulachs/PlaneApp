import 'package:paperwings/models/plane_flight_settings.dart';
import 'package:paperwings/models/plane_log_settings.dart';

class PlaneSettingsState {
  final PlaneFlightSettings flightSettings;
  final PlaneLogSettings logSettings;

  PlaneSettingsState({
    required this.flightSettings,
    required this.logSettings,
  });

  PlaneSettingsState copyWith({
    PlaneFlightSettings? flightSettings,
    PlaneLogSettings? logSettings,
  }) {
    return PlaneSettingsState(
      flightSettings: flightSettings ?? this.flightSettings,
      logSettings: logSettings ?? this.logSettings,
    );
  }
}
