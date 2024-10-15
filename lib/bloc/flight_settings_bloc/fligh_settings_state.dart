import 'package:paperwings/models/flight_settings.dart';

class FlightSettingsState {
  final FlightSettings flightSettings;
  //final EngineSettings engineSettings;

  FlightSettingsState({
    required this.flightSettings,
    //required this.engineSettings,
  });

  FlightSettingsState copyWith({
    FlightSettings? flightSettings,
    //EngineSettings? engineSettings,
  }) {
    return FlightSettingsState(
      flightSettings: flightSettings ?? this.flightSettings,
      //engineSettings: engineSettings ?? this.engineSettings,
    );
  }
}
