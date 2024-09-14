// Definir el estado del PlaneCarouselBloc
import 'package:equatable/equatable.dart';

abstract class FlyState extends Equatable {}

class FlyInitial extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyPlaneConnected extends FlyState {
  final int gyroX;
  final int gyroY;
  final int gyroZ;
  final int magnetometerX;
  final int magnetometerY;
  final int magnetometerZ;
  final int barometer;
  final int motor1Speed;
  final int motor2Speed;

  FlyPlaneConnected({
    this.gyroX = 0,
    this.gyroY = 0,
    this.gyroZ = 0,
    this.magnetometerX = 0,
    this.magnetometerY = 0,
    this.magnetometerZ = 0,
    this.barometer = 0,
    this.motor1Speed = 0,
    this.motor2Speed = 0,
  });

  @override
  List<Object?> get props => [
        gyroX,
        gyroY,
        gyroZ,
        magnetometerX,
        magnetometerY,
        magnetometerZ,
        barometer,
        motor1Speed,
        motor2Speed,
      ];

  FlyPlaneConnected copyWith({
    int? gyroX,
    int? gyroY,
    int? gyroZ,
    int? magnetometerX,
    int? magnetometerY,
    int? magnetometerZ,
    int? barometer,
    int? motor1Speed,
    int? motor2Speed,
  }) {
    return FlyPlaneConnected(
      gyroX: gyroX ?? this.gyroX,
      gyroY: gyroY ?? this.gyroY,
      gyroZ: gyroZ ?? this.gyroZ,
      magnetometerX: magnetometerX ?? this.magnetometerX,
      magnetometerY: magnetometerY ?? this.magnetometerY,
      magnetometerZ: magnetometerZ ?? this.magnetometerZ,
      barometer: barometer ?? this.barometer,
      motor1Speed: motor1Speed ?? this.motor1Speed,
      motor2Speed: motor2Speed ?? this.motor2Speed,
    );
  }
}

class FlyLoadedLoadFailed extends FlyState {
  final String errorMessage;
  FlyLoadedLoadFailed(this.errorMessage);
  @override
  List<Object> get props => [];
}

class FlyConnecting extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyPlaneDisconnected extends FlyState {
  @override
  List<Object> get props => [];
}
