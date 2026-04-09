import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/workout_session.dart';
import '../../providers/workout_provider.dart';
import '../coach_message_widget.dart';
import 'progress_chart.dart';
import 'progress_insights.dart';
import 'set_row.dart';
import 'ttg_glass_card.dart';
import 'add_set_button.dart';
import 'rest_timer_widget.dart';

final _historyProvider = FutureProvider.family(
      (ref, String exerciseId) =>
      ref.read(workoutProvider.notifier).loadHistory(exerciseId),
);

class ExerciseBlock extends ConsumerWidget {
  final ExerciseSession exercise;

  const ExerciseBlock({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutProvider.notifier);
    final historyAsync = ref.watch(_historyProvider(exercise.id));
    final suggestion = controller.getSuggestion(exercise);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      child: TtgGlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              historyAsync.when(
                data: (history) => Column(
                  children: [
                    ProgressChart(history: history),
                    const SizedBox(height: 8),
                    ProgressInsights(history: history),
                  ],
                ),
                loading: () => const SizedBox(height: 100),
                error: (_, __) => const SizedBox(),
              ),
              const SizedBox(height: 12),
              ...exercise.sets.asMap().entries.map((e) {
                final isLast = e.key == exercise.sets.length - 1;
                final set = e.value;

                return Column(
                  children: [
                    SetRow(
                      index: e.key,
                      exerciseId: exercise.id,
                      setId: set.id,
                      weight: set.weight,
                      reps: set.reps,
                      completed: set.completed,
                    ),
                    if (isLast && exercise.sets.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: RestTimerWidget(seconds: 60),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 12),
              CoachMessageWidget(
                exercise: exercise,
                controller: controller,
              ),
              const SizedBox(height: 8),
              AddSetButton(
                exerciseId: exercise.id,
                suggestedWeight: suggestion?.weight,
                suggestedReps: suggestion?.reps,
              ),
            ],
          ),
        ),
      ),
    );
  }
}