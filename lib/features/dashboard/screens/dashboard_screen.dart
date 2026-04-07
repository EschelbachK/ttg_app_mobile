import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_input_dialog.dart';
import '../state/dashboard_provider.dart';
import '../widgets/dashboard/dashboard_toggle.dart';
import '../widgets/dashboard/dashboard_top_bar.dart';
import '../widgets/training_plan_card.dart';
import '../widgets/archive/archived_plan_tile.dart';
import '../widgets/archive/archived_folder_tile.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _S();
}

class _S extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => ref.read(dashboardProvider.notifier).loadTrainingPlans());
  }

  Widget section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Center(
      child: Text(
        t,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(dashboardProvider);

    return Stack(children: [
      Positioned.fill(
        child: Image.asset("assets/images/dashboard_bg.png",
            fit: BoxFit.cover),
      ),
      Positioned.fill(
        child: Container(color: Colors.black.withOpacity(.55)),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const DashboardTopBar(),
        body: Column(children: [
          const SizedBox(height: 10),
          const DashboardToggle(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(children: [
              const Spacer(),
              Text(
                s.showArchive ? "ARCHIV" : "MEINE TRAININGSPLÄNE",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (!s.showArchive)
                IconButton(
                  icon: const Icon(Icons.add,
                      color: AppTheme.primaryRed),
                  onPressed: () => showTTGInputDialog(
                    context: context,
                    title: "Neuer Trainingsplan",
                    buttonText: "Erstellen",
                    onSubmit: (v) => ref
                        .read(dashboardProvider.notifier)
                        .createTrainingPlan(v),
                  ),
                )
              else
                const SizedBox(width: 26),
            ]),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              child: s.showArchive
                  ? ListView(children: [
                if (s.archivedPlans.isNotEmpty) ...[
                  section("ARCHIVIERTE TRAININGSPLÄNE"),
                  ...s.archivedPlans
                      .map((p) => ArchivedPlanTile(plan: p)),
                ],
                if (s.archivedFolders.isNotEmpty) ...[
                  section("ARCHIVIERTE MUSKELGRUPPEN"),
                  ...s.archivedFolders
                      .map((f) => ArchivedFolderTile(folder: f)),
                ],
              ])
                  : s.isLoading
                  ? const Center(
                  child: CircularProgressIndicator())
                  : s.trainingPlans.isEmpty
                  ? Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30)),
                  ),
                  onPressed: () =>
                      showTTGInputDialog(
                        context: context,
                        title: "Neuer Trainingsplan",
                        buttonText: "Erstellen",
                        onSubmit: (v) => ref
                            .read(dashboardProvider.notifier)
                            .createTrainingPlan(v),
                      ),
                  child: const Text(
                    "+ Neuen Plan erstellen",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
                  : ListView(
                children: s.trainingPlans
                    .map((p) => Column(children: [
                  TrainingPlanCard(plan: p),
                  const SizedBox(height: 10)
                ]))
                    .toList(),
              ),
            ),
          )
        ]),
      )
    ]);
  }
}