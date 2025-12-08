enum ManeuverType {
  loop(0),
  spin(1),
  land(2),
  takeoff(3);

  final int value;
  const ManeuverType(this.value);
}
