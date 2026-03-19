import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    /// 🔥 KEINE TRAININGSPLÄNE → CLEAN DIALOG (NEU)
    if (state.folders.isEmpty) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),

        child: Container(
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: const Color(0xFF0B0D12).withOpacity(0.92), // 🔥 neutral dark
            borderRadius: BorderRadius.circular(24),

            border: Border.all(
              color: Colors.white.withOpacity(0.18),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 40,
                offset: const Offset(0, 10),
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              const Text(
                "Kein Trainingsplan vorhanden",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 20),

              /// TEXT
              const Text(
                "Lege zuerst einen Trainingsplan an,\num diese Muskelgruppe zu importieren.",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 24),

              /// 🔥 ROTE LINIE
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xFFFF3B30),
              ),

              const SizedBox(height: 24),

              /// 🔥 EIN BUTTON
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),
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

                    /// 🔥 wechselt direkt zurück zu Plänen
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
      );
    }

    /// 🔥 NORMALER IMPORT (UNVERÄNDERT)
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(
        color: Color(0xFF1B1F23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// TITLE
          const Text(
            "In welchen Plan importieren?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// CONTEXT
          Text(
            'Für "${plan.name}" auswählen',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          ...state.folders.map((folder) {

            return ListTile(

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

                ref.read(dashboardProvider.notifier)
                    .importPlan(folder.id, plan);

                Navigator.pop(context);
              },
            );
          }),

        ],
      ),
    );
  }
}