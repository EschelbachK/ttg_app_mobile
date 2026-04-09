import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/exercise_block.dart';

class WorkoutActiveScreen extends ConsumerWidget {
  const WorkoutActiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);

    final session = state.session;

    final totalVolume = session == null
        ? 0
        : session.exercises.fold(
      0.0,
          (sum, e) => sum +
          e.sets.fold(
              0.0, (s, set) => s + set.weight * set.reps),
    );

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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Volume: ${totalVolume.toStringAsFixed(0)} kg'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: session.exercises
            .map((e) => ExerciseBlock(exercise: e))
            .toList(),
      ),
    );
  }
}