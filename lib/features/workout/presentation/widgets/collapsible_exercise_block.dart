import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/workout_session.dart';
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
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final sets = exercise.sets;

    // ✅ FIX: ALL DONE LOGIK RICHTIG DEFINIERT
    final allDone = sets.isNotEmpty &&
        sets.every((s) => s.completed == true);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: allDone
              ? kPrimaryRed
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          // 🔻 HEADER
          GestureDetector(
            onTap: () {
              setState(() => _expanded = !_expanded);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: TextStyle(
                        color: allDone ? kPrimaryRed : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // ✅ CHECK ICON WENN FERTIG
                  if (allDone)
                    const Icon(Icons.check, color: kPrimaryRed),

                  const SizedBox(width: 8),

                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),

          // 🔻 CONTENT
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  if (sets.isNotEmpty)
                    ...sets.asMap().entries.map<Widget>((entry) {
                      final set = entry.value;

                      return SetRow(
                        key: ValueKey(set.id), // ✅ FIX für ListView Bug
                        index: entry.key,
                        exerciseId: exercise.id,
                        setId: set.id,
                        weight: set.weight,
                        reps: set.reps,
                        completed: set.completed,
                      );
                    }).toList(),

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