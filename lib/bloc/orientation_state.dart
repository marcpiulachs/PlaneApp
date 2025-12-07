part of 'orientation_bloc.dart';

class OrientationState extends Equatable {
  final double yaw;
  final double pitch;
  final double roll;

  const OrientationState({this.yaw = 0, this.pitch = 0, this.roll = 0});

  OrientationState copyWith({double? yaw, double? pitch, double? roll}) {
    return OrientationState(
      yaw: yaw ?? this.yaw,
      pitch: pitch ?? this.pitch,
      roll: roll ?? this.roll,
    );
  }

  @override
  List<Object?> get props => [yaw, pitch, roll];
}
