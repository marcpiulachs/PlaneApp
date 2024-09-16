typedef TcpCallback = void Function(int value);

abstract class ITcpClient {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendArmed(bool armed);
  Future<void> sendThrottle(int throttle);

  bool get isConnected;

  // Callbacks
  void Function()? onConnect;
  void Function()? onDisconnect;
  void Function()? onConnectionFailed;
  void Function(int)? onGyroX;
  void Function(int)? onGyroY;
  void Function(int)? onGyroZ;
  void Function(int)? onMagnetometerX;
  void Function(int)? onMagnetometerY;
  void Function(int)? onMagnetometerZ;
  void Function(int)? onBarometer;
  void Function(int)? onMotor1Speed;
  void Function(int)? onMotor2Speed;
  void Function(int)? onBattery;
  void Function(int)? onSignal;
}
