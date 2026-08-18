/// Payload de la característica `yoke` (1 byte con signo, -15..15).
class BleYoke {
  BleYoke(this.value);

  final int value;

  List<int> toBytes() => [value.clamp(-15, 15) & 0xFF];
}
