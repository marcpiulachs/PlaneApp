/// Identificadores abstractos de las características BLE del avión.
enum BleCharId {
  // Comandos (WRITE, central -> periférico)
  arm,
  throttle,
  yoke,
  maneuver,
  logControl,
  calibrate,
  shutdown,
  beacon,
  pidWrite,
  setImuOrientation,
  getPidSettings,
  getImuOrientation,

  // Telemetría (NOTIFY + READ, periférico -> central)
  telemetry,
  pidValues,
  imuOrientation,
}
