import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/workout_provider.dart';
import '../widgets/workout_header.dart';
import '../widgets/exercise_block.dart';
import '../widgets/sticky_group_header.dart';

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
            child: CustomScrollView(
              slivers: [
                for (final group in session.groups) ...[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      child: StickyGroupHeader(title: group.name),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      group.exercises.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ExerciseBlock(exercise: e),
                        );
                      }).toList(),
                    ),
                  ),
                ]
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
}