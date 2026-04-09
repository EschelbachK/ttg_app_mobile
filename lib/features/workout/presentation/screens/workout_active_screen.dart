import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/exercise_block.dart';

class WorkoutActiveScreen extends ConsumerStatefulWidget {
  const WorkoutActiveScreen({super.key});

  @override
  ConsumerState<WorkoutActiveScreen> createState() => _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState extends ConsumerState<WorkoutActiveScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutProvider);
    final session = state.session;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session == null) {
      return const Scaffold(body: Center(child: Text('No active workout')));
    }

    final exercises = [...session.exercises];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Workout'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/workout/summary');
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(16),
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex--;

          final item = exercises.removeAt(oldIndex);
          exercises.insert(newIndex, item);

          ref.read(workoutProvider.notifier).reorderExercises(exercises);
        },
        children: [
          for (final e in exercises)
            Container(
              key: ValueKey(e.id),
              margin: const EdgeInsets.only(bottom: 12),
              child: ExerciseBlock(exercise: e),
            )
        ],
      ),
    );
  }
}