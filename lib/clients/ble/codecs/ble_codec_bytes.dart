import 'dart:typed_data';

/// Utilidades de serialización de los payloads de las características BLE
/// del avión. Los floats se transmiten en little-endian (struct nativo, la
/// misma convención que SlotBridgeFirmware).
///
/// Byte de disparo para las características de comando sin payload semántico
/// (shutdown, getPidSettings, getImuOrientation): el firmware solo comprueba
/// que la escritura sea válida y lanza la acción.
const int bleTriggerByte = 0x00;

List<int> writeFloat32LittleEndian(double value) {
  final bytes = Uint8List(4);
  ByteData.sublistView(bytes).setFloat32(0, value, Endian.little);
  return bytes;
}

List<double> readFloat32LittleEndian(List<int> bytes, int count) {
  final bd = ByteData.sublistView(Uint8List.fromList(bytes));
  return List.generate(count, (i) => bd.getFloat32(i * 4, Endian.little));
}