/// Payload de la característica `arm` (1 byte: 0/1).
class BleArm {
  BleArm(this.armed);

  final bool armed;

  List<int> toBytes() => [armed ? 1 : 0];
}
