import 'package:flutter/material.dart';
import '../../domain/workout_group.dart';
import 'collapsible_exercise_block.dart';

class WorkoutGroupList extends StatelessWidget {
  final List<WorkoutGroup> groups;

  const WorkoutGroupList({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final g in groups) ...[
          const SizedBox(height: 20),
          _Header(title: g.name),
          const SizedBox(height: 14),
          ...g.exercises.map(
                (e) => Padding(
              key: ValueKey('padding_${e.id}'),
              padding: const EdgeInsets.only(bottom: 16),
              child: CollapsibleExerciseBlock(
                key: ValueKey('exercise_${e.id}'),
                exercise: e,
              ),
            ),
          ),
        ],
        const SizedBox(height: 120),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    const kPrimaryRed = Color(0xFFE10600);

    return Column(
      children: [
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, kPrimaryRed, Colors.transparent],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: kPrimaryRed,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, kPrimaryRed, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}