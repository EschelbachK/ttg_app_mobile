import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/workout_session.dart';
import '../../providers/workout_provider.dart';
import 'set_row.dart';
import 'add_set_button.dart';
import 'collapsible_exercise_header.dart';

const kPrimaryRed = Color(0xFFE10600);

class CollapsibleExerciseBlock extends ConsumerStatefulWidget {
  final ExerciseSession exercise;

  const CollapsibleExerciseBlock({
    super.key,
    required this.exercise,
  });

  @override
  ConsumerState<CollapsibleExerciseBlock> createState() =>
      _CollapsibleExerciseBlockState();
}

class _CollapsibleExerciseBlockState
    extends ConsumerState<CollapsibleExerciseBlock> {
  bool _expanded = true;

  @override
  void didUpdateWidget(covariant CollapsibleExerciseBlock oldWidget) {
    super.didUpdateWidget(oldWidget);

    final sets = widget.exercise.sets;
    final allDone =
        sets.isNotEmpty && sets.every((s) => s.completed == true);

    final ctrl = ref.read(workoutProvider.notifier);

    if (allDone && ctrl.restSeconds > 0 && _expanded) {
      setState(() => _expanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final sets = exercise.sets;

    final allDone =
        sets.isNotEmpty && sets.every((s) => s.completed == true);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: allDone ? kPrimaryRed : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          CollapsibleExerciseHeader(
            title: exercise.name,
            expanded: _expanded,
            allDone: allDone,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  if (sets.isNotEmpty)
                    ...sets.asMap().entries.map((entry) {
                      final set = entry.value;

                      return SetRow(
                        key: ValueKey(set.id),
                        index: entry.key,
                        exerciseId: exercise.id,
                        setId: set.id,
                        weight: set.weight,
                        reps: set.reps,
                        completed: set.completed,
                      );
                    }),
                  const SizedBox(height: 4),
                  AddSetButton(
                    exerciseId: exercise.id,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}