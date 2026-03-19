import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';

class ImportPlanSheet extends ConsumerWidget {
  final TrainingPlan plan;

  const ImportPlanSheet({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    if (state.folders.isEmpty) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withOpacity(0.06),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kein Trainingsplan vorhanden",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Lege zuerst einen Trainingsplan an,\num diese Muskelgruppe zu importieren.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: AppTheme.primaryRed,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(dashboardProvider.notifier).showPlans();
                      },
                      child: const Text(
                        "+ Plan erstellen",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withOpacity(0.05),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "In welchen Plan importieren?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                      children: [
                        const TextSpan(text: 'Für "'),
                        TextSpan(
                          text: plan.name,
                          style: const TextStyle(
                            color: AppTheme.primaryRed,
                          ),
                        ),
                        const TextSpan(text: '" auswählen'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: state.folders.map((folder) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.12),
                                  ),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.fitness_center,
                                    size: 20,
                                    color: AppTheme.primaryRed,
                                  ),
                                  title: Text(
                                    folder.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.white38,
                                  ),
                                  onTap: () {
                                    ref
                                        .read(dashboardProvider.notifier)
                                        .importPlan(folder.id, plan);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}