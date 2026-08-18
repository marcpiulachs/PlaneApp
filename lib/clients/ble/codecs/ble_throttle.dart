/// Payload de la característica `throttle` (1 byte: porcentaje 0-100).
class BleThrottle {
  BleThrottle(this.percent);

  final int percent;

  List<int> toBytes() => [percent.clamp(0, 100)];
}
