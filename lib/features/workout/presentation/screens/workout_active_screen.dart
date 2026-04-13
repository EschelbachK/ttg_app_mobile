import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../../../core/ui/ttg_leave_workout_dialog.dart';
import '../../providers/workout_provider.dart';
import '../widgets/collapsible_exercise_block.dart';
import '../widgets/workout_start_overlay.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutActiveScreen extends ConsumerStatefulWidget {
  const WorkoutActiveScreen({super.key});

  @override
  ConsumerState<WorkoutActiveScreen> createState() =>
      _WorkoutActiveScreenState();
}

class _WorkoutActiveScreenState
    extends ConsumerState<WorkoutActiveScreen> {
  late bool _showStartOverlay;
  bool _autoFinished = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(workoutProvider);
    _showStartOverlay =
        state.session != null && !state.isPaused;
  }

  Future<void> _handleExit(BuildContext context) async {
    final controller = ref.read(workoutProvider.notifier);
    final result = await showTTGLeaveWorkoutDialog(context: context);
    if (result == null) return;

    if (result == "finish") {
      await controller.finishWorkout();
      if (!context.mounted) return;
      context.go('/workout/summary');
      return;
    }

    controller.pauseWorkout();
    if (!context.mounted) return;
    context.go('/workout/start');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutProvider);
    final controller = ref.read(workoutProvider.notifier);
    final session = state.session;

    if (session == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: TtgBackground(
          child: Center(
            child: Text('Kein Workout',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    final allCompleted = session.groups.every(
          (g) => g.exercises.every(
            (e) => e.sets.every((s) => s.completed),
      ),
    );

    if (allCompleted && !_autoFinished && !state.isFinished) {
      _autoFinished = true;
      Future.microtask(() async {
        await controller.finishWorkout();
        if (!context.mounted) return;
        context.go('/workout/summary');
      });
    }

    final totalVolume = session.groups
        .expand((g) => g.exercises)
        .fold<double>(
      0,
          (sum, e) =>
      sum + e.sets.fold<double>(0, (s, set) => s + set.weight * set.reps),
    );

    return WillPopScope(
      onWillPop: () async {
        await _handleExit(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            TtgBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    _TopBar(
                      volume: totalVolume,
                      onBack: () => _handleExit(context),
                    ),
                    Expanded(
                      child: ListView(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          for (final group in session.groups) ...[
                            const SizedBox(height: 20),
                            _PremiumGroupHeader(title: group.name),
                            const SizedBox(height: 14),
                            ...group.exercises.map(
                                  (e) => Padding(
                                padding:
                                const EdgeInsets.only(bottom: 16),
                                child: CollapsibleExerciseBlock(
                                    exercise: e),
                              ),
                            ),
                          ],
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showStartOverlay)
              WorkoutStartOverlay(
                onFinish: () {
                  if (!mounted) return;
                  setState(() => _showStartOverlay = false);
                },
              ),
            if (controller.showRest)
              _RestOverlay(
                seconds: controller.restSeconds,
                onSkip: controller.stopRestTimer,
              ),
          ],
        ),
        floatingActionButton: controller.showRest
            ? null
            : FloatingActionButton(
          backgroundColor: kPrimaryRed,
          onPressed: () async {
            await controller.finishWorkout();
            if (!context.mounted) return;
            context.go('/workout/summary');
          },
          child:
          const Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }
}

class _RestOverlay extends StatefulWidget {
  final int seconds;
  final VoidCallback onSkip;

  const _RestOverlay({
    required this.seconds,
    required this.onSkip,
  });

  @override
  State<_RestOverlay> createState() => _RestOverlayState();
}

class _RestOverlayState extends State<_RestOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
  AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.seconds / 60;

    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onSkip,
        child: Container(
          color: Colors.black.withOpacity(0.55),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Center(
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) {
                  final scale = 1 + (_pulse.value * 0.04);

                  return Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    kPrimaryRed.withOpacity(0.4),
                                    blurRadius: 80,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 220,
                              height: 220,
                              child:
                              TweenAnimationBuilder<double>(
                                tween:
                                Tween(begin: 0, end: progress),
                                duration: const Duration(
                                    milliseconds: 500),
                                builder: (_, value, __) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 10,
                                    color: kPrimaryRed,
                                    backgroundColor:
                                    Colors.white10,
                                  );
                                },
                              ),
                            ),
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                Colors.black.withOpacity(0.6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.8),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${widget.seconds}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'TIPPEN ZUM ÜBERSPRINGEN',
                          style: TextStyle(
                            color:
                            Colors.white.withOpacity(0.35),
                            letterSpacing: 3,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final double volume;
  final VoidCallback onBack;

  const _TopBar({
    required this.volume,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${volume.toStringAsFixed(0)} KG',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _PremiumGroupHeader extends StatelessWidget {
  final String title;

  const _PremiumGroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                kPrimaryRed.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: kPrimaryRed,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                kPrimaryRed.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}