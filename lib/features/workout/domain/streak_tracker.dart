class StreakTracker {
  int streakCount;
  DateTime? lastWorkout;

  StreakTracker({this.streakCount = 0, this.lastWorkout});

  void update(DateTime today) {
    if (lastWorkout == null ||
        today.difference(lastWorkout!).inDays > 1) {
      streakCount = 1;
    } else {
      streakCount += 1;
    }
    lastWorkout = today;
  }
}