// 🔥 FINAL:
// - Blur wie Bild 1 (stärker sichtbar)
// - Background sichtbar (kein dunkler Block mehr)
// - echter Glass Effekt
// - Flow bleibt korrekt (Plan erstellen + import)
// - alles klickbar

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';

class ImportPlanSheet extends ConsumerWidget {
  final TrainingPlan plan;
  final String folderId;

  const ImportPlanSheet({
    super.key,
    required this.plan,
    required this.folderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(dashboardProvider).trainingPlans;

    return Material(
      /// 🔥 HELLER OVERLAY (damit Blur sichtbar bleibt)
      color: Colors.black.withOpacity(0.15),

      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 210),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TTGGlowBorder(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),

                      /// 🔥 STARKER BLUR (wie Bild 1)
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 18,
                          sigmaY: 18,
                        ),

                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            /// 🔥 WENIGER DUNKEL → GLASS
                            color: Colors.black.withOpacity(0.25),

                            borderRadius: BorderRadius.circular(24),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "In welchen Plan importieren?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 6),

                              /// 🔥 ROTER TEXT
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 13),
                                  children: [
                                    const TextSpan(
                                      text: 'Für "',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                    TextSpan(
                                      text: plan.name,
                                      style: const TextStyle(
                                        color: AppTheme.primaryRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '" auswählen',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// 🔥 PLAN LISTE
                              ...plans.map(
                                    (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final notifier =
                                      ref.read(dashboardProvider.notifier);

                                      await notifier.importFolderToPlan(
                                        folderId: folderId,
                                        targetPlanId: p.id,
                                        name: plan.name,
                                      );

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.folder,
                                            color: AppTheme.primaryRed,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              p.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white38,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// 🔥 BUTTON (FLOW FIX)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryRed,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);

                                  await Future.delayed(
                                      const Duration(milliseconds: 120));

                                  showTTGInputDialog(
                                    context: context,
                                    title: "Neuer Trainingsplan",
                                    buttonText: "Erstellen",
                                    onSubmit: (v) async {
                                      final notifier =
                                      ref.read(dashboardProvider.notifier);

                                      /// Plan erstellen
                                      await notifier.createTrainingPlan(v);

                                      /// Reload
                                      await notifier.loadTrainingPlans();

                                      /// neuen Plan finden
                                      final newPlan = ref
                                          .read(dashboardProvider)
                                          .trainingPlans
                                          .firstWhere((p) => p.name == v);

                                      /// import + restore
                                      await notifier.importFolderToPlan(
                                        folderId: folderId,
                                        targetPlanId: newPlan.id,
                                        name: plan.name,
                                      );
                                    },
                                  );
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Plan erstellen"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}