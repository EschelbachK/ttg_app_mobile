import '../domain/workout_session.dart';

class WorkoutState {
  final WorkoutSession? session;
  final bool isLoading;

  const WorkoutState({
    this.session,
    this.isLoading = false,
  });

  WorkoutState copyWith({
    WorkoutSession? session,
    bool? isLoading,
    bool clearSession = false,
  }) {
    return WorkoutState(
      session: clearSession ? null : session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}