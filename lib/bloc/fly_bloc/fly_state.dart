// Definir el estado del PlaneCarouselBloc
import 'package:equatable/equatable.dart';
import 'package:object_3d/models/direction.dart';
import 'package:object_3d/models/telemetry.dart';

abstract class FlyState extends Equatable {}

class FlyInitial extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyPlaneConnected extends FlyState with EquatableMixin {
  final Telemetry telemetry;
  final int duration;
  final Direction direction;

  FlyPlaneConnected({
    Telemetry? telemetry,
    Direction? direction,
    this.duration = 0,
  })  : telemetry = telemetry ?? Telemetry(),
        direction = direction ?? Direction();

  FlyPlaneConnected copyWith({
    Telemetry? telemetry,
    Direction? direction,
    int? duration,
  }) {
    return FlyPlaneConnected(
      telemetry: telemetry ?? this.telemetry,
      duration: duration ?? this.duration,
      direction: direction ?? this.direction,
    );
  }

  @override
  List<Object?> get props => [telemetry, duration, direction];
}

/*
class FlyLoadedLoadFailed extends FlyState {
  final String errorMessage;
  FlyLoadedLoadFailed(this.errorMessage);
  @override
  List<Object> get props => [];
}*/

class FlyPlaneConnecting extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyPlaneDisconnected extends FlyState {
  @override
  List<Object> get props => [];
}
