import 'package:paperwings/enum/bacon_pattern.dart';

/// Payload de la característica `beacon` (1 byte: patrón del beacon).
class BleBeacon {
  BleBeacon(this.pattern);

  final BaconPattern pattern;

  List<int> toBytes() => [pattern.value];
}
