enum BaconPattern {
  none(0),
  steadyOn(1),
  steadyBoth(2),
  shortBlinks(3),
  longBlink(4),
  alternating(5),
  strobe(6),
  sos(7),
  wigwag(8),
  rotating(9);

  final int value;
  const BaconPattern(this.value);
}
