import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/api_service_provider.dart';
import '../models/training_exercise.dart';
import '../models/training_folder.dart';

class TrainingExercisesScreen extends ConsumerStatefulWidget {
  final TrainingFolder folder;

  const TrainingExercisesScreen({
    super.key,
    required this.folder,
  });

  @override
  ConsumerState<TrainingExercisesScreen> createState() =>
      _TrainingExercisesScreenState();
}

class _TrainingExercisesScreenState
    extends ConsumerState<TrainingExercisesScreen> {

  List<TrainingExercise> exercises = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final api = ref.read(apiServiceProvider);
    final data = await api.getExercises(widget.folder.id);

    setState(() {
      exercises = data;
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
      appBar: AppBar(title: Text(widget.folder.name)),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Card(
            child: ListTile(
              title: Text(exercise.name),
              onTap: () {
                // später: Sets Screen
              },
            ),
          );
        },
      ),
    );
  }
}