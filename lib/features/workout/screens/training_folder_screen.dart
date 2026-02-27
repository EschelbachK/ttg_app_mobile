import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_folder.dart';
import '../providers/workout_providers.dart';

class TrainingFolderScreen extends ConsumerWidget {
  final String planId;
  final String planName;

  const TrainingFolderScreen({
    super.key,
    required this.planId,
    required this.planName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider(planId));

    return Scaffold(
      appBar: AppBar(
        title: Text(planName),
      ),
      body: foldersAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error: $err')),
        data: (folders) =>
            _FolderList(folders: folders, planId: planId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showCreateDialog(context, ref, planId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context,
      WidgetRef ref,
      String planId,
      ) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Folder'),
          content: TextField(
            controller: controller,
            decoration:
            const InputDecoration(labelText: 'Folder name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
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
              child: const Text('Create'),
            ),
          ],
        );
      },
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
        child: Text('No folders yet.'),
      );
    }

    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];

        return Dismissible(
          key: ValueKey(folder.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding:
            const EdgeInsets.symmetric(horizontal: 20),
            child:
            const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) async {
            final api =
            ref.read(workoutApiServiceProvider);

            await api.deleteFolder(planId, folder.id);

            ref.invalidate(foldersProvider(planId));
          },
          child: ListTile(
            title: Text(folder.name),
          ),
        );
      },
    );
  }
}