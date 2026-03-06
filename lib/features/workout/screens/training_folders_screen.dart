import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_folder.dart';
import '../providers/workout_providers.dart';
import 'training_exercises_screen.dart';

class TrainingFoldersScreen extends ConsumerWidget {
  final String planId;
  final String planName;

  const TrainingFoldersScreen({
    super.key,
    required this.planId,
    required this.planName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider(planId));

    return Scaffold(
      appBar: AppBar(title: Text(planName)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: foldersAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Error: $err')),
        data: (folders) =>
            _FolderList(folders: folders, planId: planId),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Muskelgruppe hinzufügen"),
        content: TextField(
          controller: controller,
          decoration:
          const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              final api =
              ref.read(workoutApiServiceProvider);

              await api.createFolder(planId, name);
              ref.invalidate(foldersProvider(planId));

              Navigator.pop(context);
            },
            child: const Text("Erstellen"),
          )
        ],
      ),
    );
  }
}

class _FolderList extends ConsumerWidget {
  final List<TrainingFolder> folders;
  final String planId;

  const _FolderList({
    required this.folders,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (folders.isEmpty) {
      return const Center(
        child: Text("Keine Muskelgruppen vorhanden"),
      );
    }

    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];

        return ListTile(
          title: Text(folder.name),
          trailing: Text("(${folder.exerciseCount})"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TrainingExercisesScreen(folder: folder),
              ),
            );
          },
        );
      },
    );
  }
}