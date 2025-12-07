part of 'orientation_bloc.dart';

abstract class OrientationEvent extends Equatable {
  const OrientationEvent();
  @override
  List<Object?> get props => [];
}

class OrientationStart extends OrientationEvent {}

class OrientationYawChanged extends OrientationEvent {
  final double yaw;
  const OrientationYawChanged(this.yaw);
  @override
  List<Object?> get props => [yaw];
}

class OrientationPitchChanged extends OrientationEvent {
  final double pitch;
  const OrientationPitchChanged(this.pitch);
  @override
  List<Object?> get props => [pitch];
}

class OrientationRollChanged extends OrientationEvent {
  final double roll;
  const OrientationRollChanged(this.roll);
  @override
  List<Object?> get props => [roll];
}
