// Definir el estado del PlaneCarouselBloc
import 'package:equatable/equatable.dart';
import 'package:object_3d/models/direction.dart';
import 'package:object_3d/models/telemetry.dart';

abstract class FlyState extends Equatable {}

class FlyInitialState extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyLoadedState extends FlyState with EquatableMixin {
  final Telemetry telemetry;
  final int duration;
  final Direction direction;
  final bool isArmed;
  final bool isRecording;

  FlyLoadedState({
    Telemetry? telemetry,
    Direction? direction,
    this.duration = 0,
    this.isArmed = false,
    this.isRecording = false,
  })  : telemetry = telemetry ?? Telemetry(),
        direction = direction ?? Direction();

  FlyLoadedState copyWith({
    Telemetry? telemetry,
    Direction? direction,
    int? duration,
    bool? isArmed,
    bool? isRecording,
  }) {
    return FlyLoadedState(
      telemetry: telemetry ?? this.telemetry,
      duration: duration ?? this.duration,
      direction: direction ?? this.direction,
      isArmed: isArmed ?? this.isArmed,
      isRecording: isRecording ?? this.isRecording,
    );
  }

  @override
  List<Object?> get props =>
      [telemetry, duration, direction, isArmed, isRecording];
}

class FlyDisconnectedState extends FlyState {
  @override
  List<Object> get props => [];
}
