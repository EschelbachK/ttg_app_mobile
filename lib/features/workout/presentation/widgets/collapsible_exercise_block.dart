import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/workout_session.dart';
import '../../providers/workout_provider.dart';
import 'set_row.dart';
import 'add_set_button.dart';

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
    final allDone = sets.isNotEmpty && sets.every((s) => s.completed);

    final ctrl = ref.read(workoutProvider.notifier);

    if (allDone && ctrl.restSeconds > 0 && _expanded) {
      setState(() => _expanded = false);
    }

    if (!allDone && !_expanded) {
      setState(() => _expanded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    final sets = e.sets;

    final allDone = sets.isNotEmpty && sets.every((s) => s.completed);

    final isActive =
        sets.isEmpty || sets.any((s) => s.completed != true);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: allDone
              ? kPrimaryRed
              : isActive
              ? kPrimaryRed.withOpacity(0.5)
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 12, height: 2, color: kPrimaryRed),
                        const SizedBox(width: 6),
                        Text(
                          e.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            shadows: isActive
                                ? [
                              Shadow(
                                color: kPrimaryRed.withOpacity(0.6),
                                blurRadius: 12,
                              )
                            ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(width: 12, height: 2, color: kPrimaryRed),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  allDone
                      ? const Row(
                    children: [
                      Icon(Icons.check,
                          color: kPrimaryRed, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Erledigt!",
                        style: TextStyle(
                          color: kPrimaryRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      : const SizedBox(width: 60),
                ],
              ),
            ),
          ),

          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  ...sets.asMap().entries.map(
                        (entry) => SetRow(
                      key: ValueKey(entry.value.id),
                      index: entry.key,
                      exerciseId: e.id,
                      setId: entry.value.id,
                      weight: entry.value.weight,
                      reps: entry.value.reps,
                      completed: entry.value.completed,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AddSetButton(exerciseId: e.id),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}