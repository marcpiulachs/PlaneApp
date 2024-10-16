import 'package:paperwings/models/flight_settings.dart';
import 'package:paperwings/models/plane_item.dart';

class PlaneRepository {
  List<PlaneItem> fetchPlanes() {
    return [
      PlaneItem(
        imageUrl: 'assets/planes/black.png',
        title: 'Paper Monster',
        description: "A japanesse inspired plane",
        progress1: 0.3,
        progress2: 0.9,
        progress3: 0.4,
        defaultSettings: FlightSettings(
          steeringAngle: 110,
          pitchKp: 1.5,
          pitchRateKp: 0.5,
          rollKp: 0.3,
          rollRateKp: 0.05,
          yawKp: 0.5,
          yawRateKp: 0.5,
          angleOfAttack: 5,
        ),
        customSettings: FlightSettings(
          steeringAngle: 110,
          pitchKp: 1.5,
          pitchRateKp: 0.5,
          rollKp: 0.3,
          rollRateKp: 0.05,
          yawKp: 0.5,
          yawRateKp: 0.5,
          angleOfAttack: 5,
        ),
      ),
      PlaneItem(
        imageUrl: 'assets/planes/blue.png',
        title: 'K22 Destroyer',
        description: "Plane to win a war",
        progress1: 0.1,
        progress2: 0.7,
        progress3: 0.2,
        defaultSettings: FlightSettings(
          steeringAngle: 110,
          pitchKp: 1.5,
          pitchRateKp: 0.5,
          rollKp: 0.3,
          rollRateKp: 0.05,
          yawKp: 0.5,
          yawRateKp: 0.5,
          angleOfAttack: 5,
        ),
        customSettings: FlightSettings(
          steeringAngle: 110,
          pitchKp: 1.5,
          pitchRateKp: 0.5,
          rollKp: 0.3,
          rollRateKp: 0.05,
          yawKp: 0.5,
          yawRateKp: 0.5,
          angleOfAttack: 5,
        ),
      ),
      PlaneItem(
        imageUrl: 'assets/planes/orange.png',
        title: 'H22',
        description: "A japanesse inspired plane",
        progress1: 0.1,
        progress2: 0.4,
        progress3: 0.9,
        defaultSettings: FlightSettings(
          steeringAngle: 110,
          pitchKp: 1.5,
          pitchRateKp: 0.5,
          rollKp: 0.3,
          rollRateKp: 0.05,
          yawKp: 0.5,
          yawRateKp: 0.5,
          angleOfAttack: 5,
        ),
        customSettings: FlightSettings(
          steeringAngle: 110,
          pitchKp: 1.5,
          pitchRateKp: 0.5,
          rollKp: 0.3,
          rollRateKp: 0.05,
          yawKp: 0.5,
          yawRateKp: 0.5,
          angleOfAttack: 5,
        ),
      ),
    ];
  }
}
