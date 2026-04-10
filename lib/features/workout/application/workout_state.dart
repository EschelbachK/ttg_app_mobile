import 'package:ttg_app_mobile/features/workout/domain/workout_session.dart';
import 'package:ttg_app_mobile/features/workout/domain/progression_result.dart';
import 'package:ttg_app_mobile/features/workout/domain/next_session_suggestion.dart';

import 'motivation_state.dart';

class WorkoutState {
  final WorkoutSession? session;
  final bool isLoading;
  final bool isFinished;

  final ProgressionResult? progression;
  final List<NextSessionSuggestion> suggestions;
  final MotivationState? motivation;

  const WorkoutState({
    this.session,
    this.isLoading = false,
    this.isFinished = false,
    this.progression,
    this.suggestions = const [],
    this.motivation,
  });

  WorkoutState copyWith({
    WorkoutSession? session,
    bool? isLoading,
    bool? isFinished,
    ProgressionResult? progression,
    List<NextSessionSuggestion>? suggestions,
    MotivationState? motivation,
  }) {
    return WorkoutState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      isFinished: isFinished ?? this.isFinished,
      progression: progression ?? this.progression,
      suggestions: suggestions ?? this.suggestions,
      motivation: motivation ?? this.motivation,
    );
  }

  bool get hasActiveWorkout => session != null && !isFinished;
}