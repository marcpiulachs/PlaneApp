typedef TelemetryCallback = void Function(int value);
typedef ConnectionCallback = void Function();

abstract class IPlaneClient {
  Future<void> connect();
  Future<void> disconnect();

  Future<void> sendArmed(bool armed);
  Future<void> sendThrottle(int throttle);
  Future<void> sendYaw(int yaw);
  Future<void> sendRoll(int roll);
  Future<void> sendPitch(int pitch);
  Future<void> sendManeuver(int maneuver);

  bool get isConnected;

  // Campos de estadísticas
  int get packetsOk;
  int get packetsWithError;

  // Callbacks
  ConnectionCallback? onConnect;
  ConnectionCallback? onDisconnect;
  ConnectionCallback? onConnectionFailed;
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
  TelemetryCallback? onAccelerometerX;
  TelemetryCallback? onAccelerometerY;
  TelemetryCallback? onAccelerometerZ;

  // Stream que emite los cambios de conexión
  Stream<bool> get connectedStream;
}
