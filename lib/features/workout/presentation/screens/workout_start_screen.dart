import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import '../../../../core/ui/ttg_resume_workout_dialog.dart';
import '../../../dashboard/state/dashboard_provider.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../providers/workout_provider.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutStartScreen extends ConsumerStatefulWidget {
  const WorkoutStartScreen({super.key});

  @override
  ConsumerState<WorkoutStartScreen> createState() => _State();
}

class _State extends ConsumerState<WorkoutStartScreen> {
  Future<void> _triggerStart(Future<void> Function() action,
      {String? planId}) async {
    final s = ref.read(workoutProvider);

    if (s.session != null && !s.isFinished && s.isPaused) {
      if (planId != null && planId == s.session!.planId) {
        await ref
            .read(workoutProvider.notifier)
            .resumeWorkoutWithLatestPlan();
        if (!mounted) return;
        context.go('/workout/active');
        return;
      }

      final resume =
      await showTTGResumeWorkoutDialog(context: context);
      if (!mounted) return;

      if (resume == true) {
        await ref
            .read(workoutProvider.notifier)
            .resumeWorkoutWithLatestPlan();
        context.go('/workout/active');
      } else {
        await ref.read(workoutProvider.notifier).finishWorkout();
      }
      return;
    }

    await action();
    if (!mounted) return;
    context.go('/workout/active');
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(dashboardProvider).trainingPlans;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TtgBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const _Header(title: 'START WORKOUT'),

                const SizedBox(height: 20),

                _QuickStartCard(
                  onTap: () => _triggerStart(
                    ref.read(workoutProvider.notifier).startWorkout,
                  ),
                ),

                const SizedBox(height: 28),

                const _Header(title: 'WORKOUT PLÄNE'),

                const SizedBox(height: 14),

                Expanded(
                  child: plans.isEmpty
                      ? const Center(
                    child: Text(
                      'Keine Trainingspläne vorhanden',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                      : ListView.separated(
                    itemCount: plans.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final p = plans[i];
                      return StartPlanCard(
                        title: p.name,
                        onStart: () => _triggerStart(
                              () => ref
                              .read(workoutProvider.notifier)
                              .startWorkoutFromPlan(p),
                          planId: p.id,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        TTGGlowBorder(
          child: Container(
            height: 2,
            width: 240,
          ),
        ),
      ],
    );
  }
}

class StartPlanCard extends StatelessWidget {
  final String title;
  final VoidCallback onStart;

  const StartPlanCard({
    super.key,
    required this.title,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                height: 64,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.folder,
                    color: kPrimaryRed,
                    size: 23,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: kPrimaryRed.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryRed,
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryRed.withOpacity(0.5),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}

class _QuickStartCard extends StatelessWidget {
  final VoidCallback onTap;
  const _QuickStartCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 70,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
            Container(
              height: 70,
              padding:
              const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: kPrimaryRed.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flash_on,
                      color: kPrimaryRed, size: 25),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Quick Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: kPrimaryRed.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryRed,
                        boxShadow: [
                          BoxShadow(
                            color:
                            kPrimaryRed.withOpacity(0.5),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}