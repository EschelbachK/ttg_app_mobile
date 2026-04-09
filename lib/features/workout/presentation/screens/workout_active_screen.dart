import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/workout_header.dart';
import '../widgets/workout_group_block.dart';

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

    final exercises = session.groups.expand((g) => g.exercises);

    final totalVolume = exercises.fold(
      0.0,
          (sum, e) =>
      sum +
          e.sets.fold(0.0, (s, set) => s + set.weight * set.reps),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          WorkoutHeader(volume: totalVolume),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: session.groups.length,
              itemBuilder: (context, index) {
                final group = session.groups[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: WorkoutGroupBlock(group: group),
                );
              },
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