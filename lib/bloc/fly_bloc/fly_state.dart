// Definir el estado del PlaneCarouselBloc
import 'package:equatable/equatable.dart';
import 'package:paperwings/models/telemetry.dart';
import 'package:paperwings/models/user_action.dart';

abstract class FlyState extends Equatable {}

class FlyInitialState extends FlyState {
  @override
  List<Object> get props => [];
}

class FlyLoadedState extends FlyState with EquatableMixin {
  final Telemetry telemetry;
  final int duration;
  final bool isArmed;
  final bool isRecording;
  final UserAction userAction;
  final int wifiSignal;

  FlyLoadedState({
    Telemetry? telemetry,
    this.duration = 0,
    this.isArmed = false,
    this.isRecording = false,
    UserAction? userAction,
    this.wifiSignal = 0,
  })  : telemetry = telemetry ?? Telemetry(),
        userAction = userAction ?? const UserAction();

  FlyLoadedState copyWith({
    Telemetry? telemetry,
    int? duration,
    bool? isArmed,
    bool? isRecording,
    UserAction? userAction,
    int? wifiSignal,
  }) {
    return FlyLoadedState(
      telemetry: telemetry ?? this.telemetry,
      duration: duration ?? this.duration,
      isArmed: isArmed ?? this.isArmed,
      isRecording: isRecording ?? this.isRecording,
      userAction: userAction ?? this.userAction,
      wifiSignal: wifiSignal ?? this.wifiSignal,
    );
  }

  @override
  List<Object?> get props =>
      [telemetry, duration, isArmed, isRecording, userAction];
}

class FlyDisconnectedState extends FlyState {
  @override
  List<Object> get props => [];
}
