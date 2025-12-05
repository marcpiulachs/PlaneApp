abstract class IPlaneClient {
  // Estado
  Future<void> connect();
  Future<void> disconnect();

  // Funciones remotas
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

  // PID Settings - Pitch
  Future<void> sendPitchKp(double value);
  Future<void> sendPitchKi(double value);
  Future<void> sendPitchKd(double value);

  // PID Settings - Roll
  Future<void> sendRollKp(double value);
  Future<void> sendRollKi(double value);
  Future<void> sendRollKd(double value);

  // PID Settings - Yaw
  Future<void> sendYawKp(double value);
  Future<void> sendYawKi(double value);
  Future<void> sendYawKd(double value);

  // Get PID Settings
  Future<void> sendGetPIDSettings();

  //Campos de estado
  bool get isConnected;

  // Campos de estadísticas
  int get packetsOk;
  int get packetsWithError;

  // Callbacks
  Stream<double> get onGyroX;
  Stream<double> get onGyroY;
  Stream<double> get onGyroZ;
  Stream<double> get onMagnetometerX;
  Stream<double> get onMagnetometerY;
  Stream<double> get onMagnetometerZ;
  Stream<double> get onBarometer;
  Stream<double> get onMotor1Speed;
  Stream<double> get onMotor2Speed;
  Stream<double> get onBatterySoc;
  Stream<double> get onBatteryVol;
  Stream<double> get onSignal;
  Stream<double> get onAccelerometerX;
  Stream<double> get onAccelerometerY;
  Stream<double> get onAccelerometerZ;
  Stream<double> get onPitch;
  Stream<double> get onRoll;
  Stream<double> get onYaw;

  // Stream que emite los cambios de conexión
  Stream<bool> get connectedStream;
  Stream<void> get onConnect;
  Stream<void> get onDisconnect;
  Stream<void> get onConnectionFailed;
}
