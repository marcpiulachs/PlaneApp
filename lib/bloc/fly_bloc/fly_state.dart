// Definir el estado del PlaneCarouselBloc
import 'package:equatable/equatable.dart';
import 'package:object_3d/models/telemetry.dart';

abstract class FlyState extends Equatable {}

class FlyInitial extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyPlaneConnected extends FlyState with EquatableMixin {
  final Telemetry telemetry;
  final int duration;

  FlyPlaneConnected({
    Telemetry? telemetry,
    this.duration = 0,
  }) : telemetry = telemetry ?? Telemetry();

  @override
  List<Object?> get props => [telemetry, duration];

  FlyPlaneConnected copyWith({
    Telemetry? telemetry,
    int? duration,
  }) {
    return FlyPlaneConnected(
      telemetry: telemetry ?? this.telemetry,
      duration: duration ?? this.duration,
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
