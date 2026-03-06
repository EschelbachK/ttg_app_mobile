import 'package:flutter/material.dart';

import '../../../core/layout/app_layout.dart';

class TrainingSetScreen extends StatelessWidget {
  final String exerciseId;
  const TrainingSetScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Sets (Exercise $exerciseId)',
      child: const Center(child: Text('Workout Sets here')),
    );
  }
}
