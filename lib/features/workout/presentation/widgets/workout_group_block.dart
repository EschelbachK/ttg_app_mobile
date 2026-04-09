import 'package:flutter/material.dart';
import '../../domain/workout_group.dart';
import 'exercise_block.dart';

class WorkoutGroupBlock extends StatelessWidget {
  final WorkoutGroup group;

  const WorkoutGroupBlock({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            group.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...group.exercises.map(
              (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExerciseBlock(exercise: e),
          ),
        ),
      ],
    );
  }
}