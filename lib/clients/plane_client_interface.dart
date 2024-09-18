typedef TelemetryCallback = void Function(int value);

abstract class IPlaneClient {
  Future<void> connect();
  Future<void> disconnect();

  Future<void> sendArmed(bool armed);
  Future<void> sendThrottle(int throttle);
  Future<void> sendYaw(int yaw);
  Future<void> sendRoll(int roll);
  Future<void> sendPitch(int pitch);

  bool get isConnected;

  // Callbacks
  void Function()? onConnect;
  void Function()? onDisconnect;
  void Function()? onConnectionFailed;
  TelemetryCallback? onGyroX;
  TelemetryCallback? onGyroY;
  TelemetryCallback? onGyroZ;
  TelemetryCallback? onMagnetometerX;
  TelemetryCallback? onMagnetometerY;
  TelemetryCallback? onMagnetometerZ;
  TelemetryCallback? onBarometer;
  TelemetryCallback? onMotor1Speed;
  TelemetryCallback? onMotor2Speed;
  TelemetryCallback? onBattery;
  TelemetryCallback? onSignal;

  // Stream que emite los cambios de conexión
  Stream<bool> get connectedStream;
}
