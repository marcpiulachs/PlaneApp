import 'package:paperwings/models/telemetry.dart';

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
  Future<void> sendImuOrientation(int orientation);
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

  // Logging Settings
  Future<void> sendLogIMU(bool enabled);
  Future<void> sendLogThrust(bool enabled);
  Future<void> sendLogBattery(bool enabled);
  Future<void> sendLogMotor(bool enabled);

  //Campos de estado
  bool get isConnected;

  // Campos de estadísticas
  int get packetsOk;
  int get packetsWithError;

  // Stream con la telemetría del avión
  Stream<Telemetry> get telemetryStream;

  // Stream que emite los cambios de conexión
  Stream<bool> get connectedStream;
  Stream<void> get onConnect;
  Stream<void> get onDisconnect;
  Stream<void> get onConnectionFailed;
}
