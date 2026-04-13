import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/workout_session.dart';
import '../../providers/workout_provider.dart';
import 'set_row.dart';
import 'add_set_button.dart';

const kPrimaryRed = Color(0xFFE10600);

class CollapsibleExerciseBlock extends ConsumerStatefulWidget {
  final ExerciseSession exercise;

  const CollapsibleExerciseBlock({super.key, required this.exercise});

  @override
  ConsumerState<CollapsibleExerciseBlock> createState() => _State();
}

class _State extends ConsumerState<CollapsibleExerciseBlock> {
  bool collapsed = false;

  bool get allDone =>
      widget.exercise.sets.every((s) => s?.completed == true);

  @override
  void didUpdateWidget(covariant CollapsibleExerciseBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    final showRest = ref.read(workoutProvider.notifier).showRest;
    if (allDone && showRest) collapsed = true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(workoutProvider.notifier);
    final suggestion = controller.getSuggestion(widget.exercise);
    final sets = widget.exercise.sets;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => collapsed = !collapsed),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 10, height: 2, color: kPrimaryRed),
                    const SizedBox(width: 6),
                    Text(
                      widget.exercise.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 2, color: kPrimaryRed),
                  ],
                ),

                if (collapsed)
                  const Positioned(
                    left: 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ),

                if (allDone)
                  Positioned(
                    right: 0,
                    child: Row(
                      children: const [
                        Icon(Icons.check, color: kPrimaryRed, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Erledigt!',
                          style: TextStyle(
                            color: kPrimaryRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          if (!collapsed) ...[
            const SizedBox(height: 12),
            ...sets.asMap().entries.map((entry) {
              final set = entry.value;
              if (set == null) return const SizedBox();
              return SetRow(
                index: entry.key,
                exerciseId: widget.exercise.id,
                setId: set.id,
                weight: set.weight,
                reps: set.reps,
                completed: set.completed,
              );
            }),
            const SizedBox(height: 4),
            AddSetButton(
              exerciseId: widget.exercise.id,
              suggestedWeight: suggestion?.weight,
              suggestedReps: suggestion?.reps,
            ),
          ],
        ],
      ),
    );
  }
}