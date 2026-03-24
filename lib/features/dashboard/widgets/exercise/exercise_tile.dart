import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import 'package:ttg_app_mobile/features/dashboard/models/exercise.dart';
import '../../models/exercise_set.dart';

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;
  final bool isArchived;

  const ExerciseTile({
    super.key,
    required this.exercise,
    this.isArchived = false,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 8),
                          if (!widget.isArchived)
                            const Icon(
                              Icons.more_vert,
                              color: Colors.white38,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (expanded) ...[
                    const Divider(color: Colors.white12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Übungsbild",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(Icons.drag_indicator, color: Colors.white38, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Center(
                              child: Text(
                                "SATZ",
                                style: TextStyle(color: Colors.white38, fontSize: 12),
                              ),
                            ),
                          ),
                          Icon(Icons.fitness_center, color: Colors.white38, size: 16),
                          SizedBox(width: 4),
                          Expanded(
                            child: Center(
                              child: Text(
                                "GEWICHT",
                                style: TextStyle(color: Colors.white38, fontSize: 12),
                              ),
                            ),
                          ),
                          Icon(Icons.repeat, color: Colors.white38, size: 16),
                          SizedBox(width: 4),
                          Expanded(
                            child: Center(
                              child: Text(
                                "WDH",
                                style: TextStyle(color: Colors.white38, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget.isArchived
                        ? Column(
                      children: [
                        for (int i = 0; i < exercise.sets.length; i++)
                          _buildSetRow(
                            exercise.sets[i],
                            i,
                            key: ValueKey(i),
                          ),
                      ],
                    )
                        : ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        final sets = [...exercise.sets];

                        if (newIndex > oldIndex) {
                          newIndex--;
                        }

                        final item = sets.removeAt(oldIndex);
                        sets.insert(newIndex, item);

                        setState(() {
                          exercise.sets
                            ..clear()
                            ..addAll(sets);
                        });
                      },
                      children: [
                        for (int i = 0; i < exercise.sets.length; i++)
                          _buildSetRow(
                            exercise.sets[i],
                            i,
                            key: ValueKey(i),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetRow(ExerciseSet set, int index, {required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Colors.white38),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Text(
                "${index + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${set.weight} kg",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${set.reps}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
