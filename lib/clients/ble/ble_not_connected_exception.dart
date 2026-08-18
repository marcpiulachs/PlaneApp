class BleNotConnectedException implements Exception {
  const BleNotConnectedException(this.deviceId);

  final String deviceId;

  @override
  String toString() => 'Bluetooth device $deviceId is not connected';
}
