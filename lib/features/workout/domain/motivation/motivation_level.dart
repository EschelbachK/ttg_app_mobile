enum MotivationLevel {
  low,
  medium,
  high,
  extreme;

  bool get isHigh => this == high || this == extreme;
}