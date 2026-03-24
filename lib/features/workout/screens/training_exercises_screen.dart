import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';

class TrainingExercisesScreen extends StatelessWidget {
  final String folderId;
  final String planId;

  const TrainingExercisesScreen({
    super.key,
    required this.folderId,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Exercises (Plan $planId)',
      child: ListView(
        children: [
          ListTile(
            title: const Text('Exercise 1'),
            onTap: () => context.go(
              '/folders/$folderId/plans/$planId/exercises/99/sets',
            ),
          ),
        ],
      ),
    );
  }
}
