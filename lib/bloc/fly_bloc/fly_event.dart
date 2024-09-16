// Definir los eventos del PlaneCarouselBloc
abstract class FlyEvent {}

class TcpClientConnect extends FlyEvent {}

class TcpClientConnected extends FlyEvent {}

class TcpClientDisconnected extends FlyEvent {}

class GyroXUpdated extends FlyEvent {
  final int value;
  GyroXUpdated(this.value);
}

class GyroYUpdated extends FlyEvent {
  final int value;
  GyroYUpdated(this.value);
}

class GyroZUpdated extends FlyEvent {
  final int value;
  GyroZUpdated(this.value);
}

class MagnetometerXUpdated extends FlyEvent {
  final int value;
  MagnetometerXUpdated(this.value);
}

class MagnetometerYUpdated extends FlyEvent {
  final int value;
  MagnetometerYUpdated(this.value);
}

class MagnetometerZUpdated extends FlyEvent {
  final int value;
  MagnetometerZUpdated(this.value);
}

class BarometerUpdated extends FlyEvent {
  final int value;
  BarometerUpdated(this.value);
}

class Motor1SpeedUpdated extends FlyEvent {
  final int value;
  Motor1SpeedUpdated(this.value);
}

class Motor2SpeedUpdated extends FlyEvent {
  final int value;
  Motor2SpeedUpdated(this.value);
}

class BatteryUpdated extends FlyEvent {
  final int value;
  BatteryUpdated(this.value);
}

class SignalUpdated extends FlyEvent {
  final int value;
  SignalUpdated(this.value);
}

class SendArmed extends FlyEvent {
  final bool isArmed;

  SendArmed(this.isArmed);
}

class SendThrottle extends FlyEvent {
  final int throttleValue;

  SendThrottle(this.throttleValue);
}

class TimerUpdated extends FlyEvent {
  final int seconds;

  TimerUpdated(this.seconds);

  @override
  List<Object?> get props => [seconds];
}
