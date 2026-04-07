import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/dashboard/widgets/training_folder_plan_tile.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ttg_glow_border.dart';
import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';

class TrainingPlanCard extends ConsumerWidget {
  final TrainingPlan plan;

  const TrainingPlanCard({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    final muscleGroups = state.folders
        .where((f) =>
    f.trainingPlanId == plan.id &&
        f.name.trim().isNotEmpty &&
        f.name.toLowerCase() != "allgemein")
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.folder,
                          color: AppTheme.primaryRed),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          plan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.white54, size: 18),
                        onPressed: () {
                          final controller =
                          TextEditingController(text: plan.name);

                          showDialog(
                            context: context,
                            builder: (dialogContext) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.black.withOpacity(0.35),
                                      borderRadius:
                                      BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white
                                            .withOpacity(0.25),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        const Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Text(
                                            "Trainingsplan umbenennen",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: controller,
                                          cursorColor: Colors.white,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration:
                                          const InputDecoration(
                                            hintText:
                                            "Name eingeben",
                                            hintStyle: TextStyle(
                                                color:
                                                Colors.white38),
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme
                                                    .primaryRed,
                                              ),
                                            ),
                                            focusedBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme
                                                    .primaryRed,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 22),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      dialogContext),
                                              child: const Text(
                                                "Abbrechen",
                                                style: TextStyle(
                                                    color:
                                                    Colors.white70),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              style:
                                              ElevatedButton.styleFrom(
                                                backgroundColor:
                                                AppTheme.primaryRed,
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      24),
                                                ),
                                              ),
                                              onPressed: () {
                                                final name =
                                                controller.text
                                                    .trim();
                                                if (name.isEmpty)
                                                  return;

                                                Navigator.pop(
                                                    dialogContext);
                                                notifier.renamePlan(
                                                    plan.id, name);
                                              },
                                              child: const Text(
                                                "Speichern",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert,
                            color: Colors.white54),
                        onSelected: (value) {
                          if (value == 'delete') {
                            notifier.deletePlan(plan.id);
                          }
                          if (value == 'archive') {
                            notifier.archivePlan(plan.id);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                              value: 'archive',
                              child: Text('Archivieren')),
                          PopupMenuItem(
                              value: 'delete',
                              child: Text('Löschen')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...muscleGroups.map((group) {
                    return PlanTile(
                      folder: group,
                      onDelete: () =>
                          notifier.deleteFolder(group.id),
                      onMoveUp: () =>
                          notifier.moveFolderUp(group.id),
                      onMoveDown: () =>
                          notifier.moveFolderDown(group.id),
                      onArchive: () =>
                          notifier.archiveFolder(group.id),
                      onDuplicate: () =>
                          notifier.duplicateFolder(group.id),
                    );
                  }),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      final controller = TextEditingController();

                      showDialog(
                        context: context,
                        builder: (dialogContext) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color:
                                  Colors.black.withOpacity(0.35),
                                  borderRadius:
                                  BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white
                                        .withOpacity(0.25),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    const Align(
                                      alignment:
                                      Alignment.centerLeft,
                                      child: Text(
                                        "Neue Muskelgruppe",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: controller,
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                          color: Colors.white),
                                      decoration:
                                      const InputDecoration(
                                        hintText:
                                        "Name eingeben",
                                        hintStyle: TextStyle(
                                            color:
                                            Colors.white38),
                                        enabledBorder:
                                        UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppTheme
                                                .primaryRed,
                                          ),
                                        ),
                                        focusedBorder:
                                        UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppTheme
                                                .primaryRed,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(
                                                  dialogContext),
                                          child: const Text(
                                            "Abbrechen",
                                            style: TextStyle(
                                                color:
                                                Colors.white70),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          style:
                                          ElevatedButton.styleFrom(
                                            backgroundColor:
                                            AppTheme.primaryRed,
                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  24),
                                            ),
                                          ),
                                          onPressed: () {
                                            final name =
                                            controller.text
                                                .trim();
                                            if (name.isEmpty)
                                              return;

                                            Navigator.pop(
                                                dialogContext);
                                            notifier.addFolder(
                                                plan.id, name);
                                          },
                                          child: const Text(
                                            "Erstellen",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "+ Muskelgruppe hinzufügen",
                          style: TextStyle(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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