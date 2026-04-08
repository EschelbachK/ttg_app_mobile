import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/dashboard_provider.dart';
import '../../../core/layout/app_layout.dart';

class TrainingExercisesScreen extends ConsumerWidget {
  final String folderId;
  final String planId;

  const TrainingExercisesScreen({super.key, required this.folderId, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folder = ref.watch(dashboardProvider).folders.firstWhere(
          (f) => f.id == folderId,
      orElse: () => throw Exception('Folder not found'),
    );
    final exercises = folder.exercises;

    return AppLayout(
      title: folder.name,
      child: exercises.isEmpty
          ? const Center(child: Text('Noch keine Übungen hinzugefügt'))
          : ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (_, i) {
          final e = exercises[i];
          return ListTile(
            title: Text(e.name),
            onTap: () => Navigator.pushNamed(context, '/workout/exercises/${e.id}/sets'),
          );
        },
      ),
    );
  }
}