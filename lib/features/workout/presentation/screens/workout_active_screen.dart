import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/exercise_block.dart';
import '../widgets/workout_header.dart';

class WorkoutActiveScreen extends ConsumerWidget {
  const WorkoutActiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);
    final session = state.session;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('No active workout')),
      );
    }

    final exercises = [...session.exercises];

    final totalVolume = exercises.fold(
      0.0,
          (sum, e) => sum +
          e.sets.fold(0.0, (s, set) => s + set.weight * set.reps),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          WorkoutHeader(volume: totalVolume),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.all(16),
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final item = exercises.removeAt(oldIndex);
                exercises.insert(newIndex, item);
                ref
                    .read(workoutProvider.notifier)
                    .reorderExercises(exercises);
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/workout/summary');
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}