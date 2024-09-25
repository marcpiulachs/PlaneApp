class Direction {
  final int pitch;
  final int yaw;
  final int roll;

  Direction({
    this.pitch = 0,
    this.yaw = 0,
    this.roll = 0,
  });

  Direction copyWith({
    int? pitch,
    int? yaw,
    int? roll,
  }) {
    return Direction(
      pitch: pitch ?? this.pitch,
      yaw: yaw ?? this.yaw,
      roll: roll ?? this.roll,
    );
  }
}
