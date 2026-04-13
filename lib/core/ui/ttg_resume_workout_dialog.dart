import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/core/ui/ttg_dialog_actions.dart';
import '../../features/workout/providers/workout_provider.dart';
import '../../features/dashboard/state/dashboard_provider.dart';
import '../theme/app_theme.dart';

Future<bool?> showTTGResumeWorkoutDialog({
  required BuildContext context,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (c) => Consumer(
      builder: (_, ref, __) {
        final workout = ref.watch(workoutProvider);
        final dashboard = ref.watch(dashboardProvider);

        final planName = dashboard.trainingPlans
            .firstWhere(
              (p) => p.id == workout.session?.planId,
          orElse: () => dashboard.trainingPlans.first,
        )
            .name;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Workout fortsetzen?",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                        children: [
                          const TextSpan(text: 'Dein Workout "'),
                          TextSpan(
                            text: planName,
                            style: const TextStyle(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const TextSpan(text: '" ist noch aktiv! '),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: AppTheme.primaryRed),
                    const SizedBox(height: 24),
                    TTGDialogActions(
                      cancelText: "Neu starten",
                      confirmText: "Fortsetzen",
                      onCancel: () => Navigator.pop(c, false),
                      onConfirm: () => Navigator.pop(c, true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}