import 'package:paperwings/enum/maneuver_type.dart';

/// Payload de la característica `maneuver` (1 byte: tipo de maniobra).
class BleManeuver {
  BleManeuver(this.maneuver);

  final ManeuverType maneuver;

  List<int> toBytes() => [maneuver.value];
}
