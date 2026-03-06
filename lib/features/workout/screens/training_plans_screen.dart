import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/workout/screens/training_plans_screen.dart';

import '../models/training_folder.dart';
import 'training_exercises_screen.dart';

class TrainingFoldersScreen extends ConsumerStatefulWidget {
  final String planId;
  final String planName;

  const TrainingFoldersScreen({
    super.key,
    required this.planId,
    required this.planName,
  });

  @override
  ConsumerState<TrainingFoldersScreen> createState() =>
      _TrainingFoldersScreenState();
}

class _TrainingFoldersScreenState
    extends ConsumerState<TrainingFoldersScreen> {

  List<TrainingFolder> folders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFolders();
  }

  Future<void> loadFolders() async {
    final api = ref.read(apiServiceProvider);
    final data = await api.getFolders(widget.planId);

    setState(() {
      folders = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.planName)),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];

          return Card(
            child: ListTile(
              title: Text(folder.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainingExercisesScreen(
                      folder: folder,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}