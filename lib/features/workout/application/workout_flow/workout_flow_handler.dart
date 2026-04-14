import '../workout_state.dart';
import '../../domain/workout_session.dart';
import '../../domain/workout_group.dart';

class WorkoutFlowHandler {
  WorkoutState evaluateSetCompletion({
    required WorkoutState state,
    required WorkoutSession before,
    required WorkoutSession after,
    required String exerciseId,
    required void Function(String exerciseId) onSetFocus,
    required void Function(int seconds, String? message) startRestTimer,
    required void Function() triggerFinishFlow,
  }) {
    final groupBefore = before.groups.firstWhere(
          (g) => g.exercises.any((e) => e.id == exerciseId),
    );

    final groupAfter = after.groups.firstWhere(
          (g) => g.exercises.any((e) => e.id == exerciseId),
    );

    final beforeRemaining = groupBefore.exercises
        .expand((e) => e.sets)
        .where((s) => s.completed != true)
        .length;

    final afterRemaining = groupAfter.exercises
        .expand((e) => e.sets)
        .where((s) => s.completed != true)
        .length;

    final groupIndex = after.groups.indexOf(groupAfter);
    final isLastGroup = groupIndex == after.groups.length - 1;

    final justFinishedGroup =
        beforeRemaining > 0 && afterRemaining == 0;

    if (justFinishedGroup) {
      return _handleGroupFinished(
        state: state,
        session: after,
        groupIndex: groupIndex,
        isLastGroup: isLastGroup,
        groupBefore: groupBefore,
        onSetFocus: onSetFocus,
        startRestTimer: startRestTimer,
        triggerFinishFlow: triggerFinishFlow,
      );
    }

    return state;
  }

  WorkoutState _handleGroupFinished({
    required WorkoutState state,
    required WorkoutSession session,
    required int groupIndex,
    required bool isLastGroup,
    required WorkoutGroup groupBefore,
    required void Function(String exerciseId) onSetFocus,
    required void Function(int seconds, String? message) startRestTimer,
    required void Function() triggerFinishFlow,
  }) {
    if (isLastGroup) {
      triggerFinishFlow();
      return state.copyWith(triggerFinishFlow: true);
    }

    final next = session.groups[groupIndex + 1];
    final nextExercise = next.exercises.first;

    onSetFocus(nextExercise.id);

    startRestTimer(
      60,
      '🔥 ${groupBefore.name} abgeschlossen\n➡️ Nächste: ${next.name}',
    );

    return state.copyWith(activeExerciseId: nextExercise.id);
  }
}