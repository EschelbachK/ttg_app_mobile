enum MotivationType {
  pr,
  streak,
  milestone,
  comeback,
  neutral;

  bool get isPositive => this != neutral;
}