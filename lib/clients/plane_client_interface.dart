typedef TelemetryCallback = void Function(double value);
typedef ConnectionCallback = void Function();

abstract class IPlaneClient {
  Future<void> connect();
  Future<void> disconnect();

  Future<void> sendArmed(bool armed);
  Future<void> sendThrottle(int throttle);
  Future<void> sendYoke(int yoke);
  Future<void> sendManeuver(int maneuver);
  Future<void> sendBeacon(int beacon);
  Future<void> sendShutdown();
  Future<void> sendKD(double value);
  Future<void> sendKP(double value);
  Future<void> sendKI(double value);
  Future<void> sendCalibrateIMU();
  Future<void> sendCalibrateMAG();

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
  TelemetryCallback? onBatterySoc;
  TelemetryCallback? onBatteryVol;
  TelemetryCallback? onSignal;
  TelemetryCallback? onAccelerometerX;
  TelemetryCallback? onAccelerometerY;
  TelemetryCallback? onAccelerometerZ;
  TelemetryCallback? onPitch;
  TelemetryCallback? onRoll;
  TelemetryCallback? onYaw;

  // Stream que emite los cambios de conexión
  Stream<bool> get connectedStream;
}
