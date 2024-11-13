import 'package:paperwings/models/flight_settings.dart';

class PlaneSettingsState {
  final FlightSettings flightSettings;

  PlaneSettingsState({
    required this.flightSettings,
  });

  PlaneSettingsState copyWith({
    FlightSettings? flightSettings,
  }) {
    return PlaneSettingsState(
      flightSettings: flightSettings ?? this.flightSettings,
    );
  }
}
