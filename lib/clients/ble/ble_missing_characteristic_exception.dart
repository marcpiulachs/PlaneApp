class BleMissingCharacteristicException implements Exception {
  const BleMissingCharacteristicException(this.message);

  final String message;

  @override
  String toString() => 'BLE characteristic missing: $message';
}
