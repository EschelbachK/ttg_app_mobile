import 'package:flutter/material.dart';
import '../../../core/layout/app_layout.dart';

class TrainingFoldersScreen extends StatelessWidget {
  const TrainingFoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Workout',
      child: Center(
        child: Text(
          'WORKOUT OK',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}