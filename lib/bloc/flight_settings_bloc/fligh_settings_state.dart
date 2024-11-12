import 'package:paperwings/models/flight_settings.dart';

class FlightSettingsState {
  final FlightSettings flightSettings;

  FlightSettingsState({
    required this.flightSettings,
  });

  FlightSettingsState copyWith({
    FlightSettings? flightSettings,
  }) {
    return FlightSettingsState(
      flightSettings: flightSettings ?? this.flightSettings,
    );
  }
}
