import 'package:ttg_app_mobile/features/workout/domain/workout_session.dart';
import 'package:ttg_app_mobile/features/workout/domain/progression_result.dart';
import 'package:ttg_app_mobile/features/workout/domain/next_session_suggestion.dart';
import 'motivation_state.dart';

class WorkoutState {
  final WorkoutSession? session;
  final bool isLoading;
  final bool isFinished;
  final bool isPaused;
  final ProgressionResult? progression;
  final List<NextSessionSuggestion> suggestions;
  final MotivationState? motivation;
  final String? restMessage;
  final bool triggerFinishFlow;
  final String? activeExerciseId;

  const WorkoutState({
    this.session,
    this.isLoading = false,
    this.isFinished = false,
    this.isPaused = false,
    this.progression,
    this.suggestions = const [],
    this.motivation,
    this.restMessage,
    this.triggerFinishFlow = false,
    this.activeExerciseId,
  });

  WorkoutState copyWith({
    WorkoutSession? session,
    bool? isLoading,
    bool? isFinished,
    bool? isPaused,
    ProgressionResult? progression,
    List<NextSessionSuggestion>? suggestions,
    MotivationState? motivation,
    String? restMessage,
    bool clearRestMessage = false,
    bool? triggerFinishFlow,
    String? activeExerciseId,
  }) {
    return WorkoutState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      isFinished: isFinished ?? this.isFinished,
      isPaused: isPaused ?? this.isPaused,
      progression: progression ?? this.progression,
      suggestions: suggestions ?? this.suggestions,
      motivation: motivation ?? this.motivation,
      restMessage: clearRestMessage ? null : (restMessage ?? this.restMessage),
      triggerFinishFlow: triggerFinishFlow ?? this.triggerFinishFlow,
      activeExerciseId: activeExerciseId ?? this.activeExerciseId,
    );
  }

  bool get hasActiveWorkout =>
      session != null && !isFinished && !isPaused;
}