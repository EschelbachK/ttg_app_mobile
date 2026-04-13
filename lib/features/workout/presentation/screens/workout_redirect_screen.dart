import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import 'workout_active_screen.dart';
import 'workout_start_screen.dart';

class WorkoutRedirectScreen extends ConsumerWidget {
  const WorkoutRedirectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutProvider);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isActiveWorkout =
        state.session != null && !state.isFinished && !state.isPaused;

    return isActiveWorkout
        ? const WorkoutActiveScreen()
        : const WorkoutStartScreen();
  }
}