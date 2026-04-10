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
    final controller = ref.read(workoutProvider.notifier);
    final session = state.session;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (session == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Kein aktives Workout',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final exercises = session.groups.expand((g) => g.exercises);

    final totalVolume = exercises.fold(
      0.0,
          (sum, e) =>
      sum + e.sets.fold(0.0, (s, set) => s + set.weight * set.reps),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            WorkoutHeader(volume: totalVolume),

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  for (final group in session.groups) ...[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyHeaderDelegate(
                        child: StickyGroupHeader(title: group.name),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final e = group.exercises[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: ExerciseBlock(exercise: e),
                          );
                        },
                        childCount: group.exercises.length,
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          await controller.finishWorkout();
          Navigator.pushNamed(context, '/workout/summary');
        },
        child: const Icon(Icons.check, color: Colors.black),
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
    return Container(
      color: Colors.black,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
}