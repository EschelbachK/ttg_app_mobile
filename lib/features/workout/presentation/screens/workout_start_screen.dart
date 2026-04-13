import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ui/ttg_resume_workout_dialog.dart';
import '../../../dashboard/state/dashboard_provider.dart';
import '../../../../core/ui/ttg_background.dart';
import '../../providers/workout_provider.dart';
import '../widgets/ttg_section_title.dart';
import '../training_plan_card.dart';

const kPrimaryRed = Color(0xFFE10600);

class WorkoutStartScreen extends ConsumerStatefulWidget {
  const WorkoutStartScreen({super.key});

  @override
  ConsumerState<WorkoutStartScreen> createState() => _State();
}

class _State extends ConsumerState<WorkoutStartScreen> {
  Future<void> _triggerStart(
      Future<void> Function() action, {
        String? planId,
      }) async {
    final state = ref.read(workoutProvider);

    if (state.session != null &&
        !state.isFinished &&
        state.isPaused) {
      final currentPlanId = state.session!.planId;

      if (planId != null && planId == currentPlanId) {
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
        await ref
            .read(workoutProvider.notifier)
            .finishWorkout();
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
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Center(
                    child:
                    TtgSectionTitle(title: 'START WORKOUT')),
                const SizedBox(height: 20),

                _QuickStartCard(
                  onTap: () => _triggerStart(
                    ref
                        .read(workoutProvider.notifier)
                        .startWorkout,
                  ),
                ),

                const SizedBox(height: 28),
                const Center(
                    child: TtgSectionTitle(
                        title: 'TRAININGSPLÄNE')),
                const SizedBox(height: 14),

                Expanded(
                  child: plans.isEmpty
                      ? const Center(
                    child: Text(
                      'Keine Trainingspläne vorhanden',
                      style:
                      TextStyle(color: Colors.white54),
                    ),
                  )
                      : ListView.separated(
                    itemCount: plans.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 14),
                    itemBuilder: (_, index) {
                      final p = plans[index];
                      return _PlanGlassWrapper(
                        child: TrainingPlanCard(
                          plan: p,
                          onStart: () => _triggerStart(
                                () => ref
                                .read(workoutProvider
                                .notifier)
                                .startWorkoutFromPlan(p),
                            planId: p.id,
                          ),
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
              filter:
              ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(22),
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(22),
                border: Border.all(
                    color: kPrimaryRed.withOpacity(0.4)),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kPrimaryRed,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                          kPrimaryRed.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Quick Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color:
                      Colors.white.withOpacity(0.4),
                      size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanGlassWrapper extends StatelessWidget {
  final Widget child;
  const _PlanGlassWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          BackdropFilter(
            filter:
            ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.06)),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}