import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/core/ui/ttg_glow_border.dart';
import 'package:ttg_app_mobile/core/theme/app_theme.dart';
import 'package:ttg_app_mobile/features/dashboard/models/training_folder.dart';
import 'package:ttg_app_mobile/features/dashboard/state/dashboard_provider.dart';
import 'package:ttg_app_mobile/features/dashboard/state/active_plan_provider.dart';
import 'package:ttg_app_mobile/features/dashboard/widgets/plan_tile.dart';

class FolderCard extends ConsumerStatefulWidget {
  final TrainingFolder folder;

  const FolderCard({super.key, required this.folder});

  @override
  ConsumerState<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends ConsumerState<FolderCard> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(dashboardProvider.notifier);
    final folder = widget.folder;
    final planId = ref.read(activePlanIdProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.folder, color: AppTheme.primaryRed),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  folder.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  folder.bodyRegion,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final controller = TextEditingController(text: folder.name);

                              showDialog(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.6),
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.25),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white.withOpacity(0.25)),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Ordner umbenennen",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller: controller,
                                                cursorColor: Colors.white,
                                                style: const TextStyle(color: Colors.white),
                                                decoration: const InputDecoration(
                                                  hintText: "Name eingeben",
                                                  hintStyle: TextStyle(color: Colors.white38),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: AppTheme.primaryRed),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: AppTheme.primaryRed),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text("Abbrechen", style: TextStyle(color: Colors.white70)),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppTheme.primaryRed,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      final name = controller.text.trim();
                                                      if (name.isEmpty) return;
                                                      notifier.renameFolder(folder.id, name);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Speichern",
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.edit, color: Colors.white54, size: 18),
                            ),
                          ),
                          Icon(
                            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white54),
                            onSelected: (value) async {
                              if (value == 'archive') {
                                notifier.archiveFolder(folder.id);
                              }
                              if (value == 'delete') {
                                await Future.delayed(Duration.zero);
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) => Dialog(
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
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Ordner löschen",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Wirklich löschen?",
                                                  style: TextStyle(color: Colors.white54),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              const Divider(color: AppTheme.primaryRed),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(dialogContext).pop(false),
                                                    child: const Text("Abbrechen", style: TextStyle(color: Colors.white70)),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppTheme.primaryRed,
                                                      foregroundColor: Colors.white,
                                                    ),
                                                    onPressed: () => Navigator.of(dialogContext).pop(true),
                                                    child: const Text("Löschen"),
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
                                if (confirm == true && planId != null) {
                                  notifier.deleteFolder(planId, folder.id);
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'archive', child: Text("Ordner archivieren")),
                              PopupMenuItem(value: 'delete', child: Text("Ordner löschen")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (expanded) ...[
                    ...folder.plans.map(
                          (p) => PlanTile(
                        folderId: folder.id,
                        plan: p,
                        onDelete: () => notifier.deletePlan(folder.id, p.id),
                        onMoveUp: () => notifier.movePlanUp(folder.id, p.id),
                        onMoveDown: () => notifier.movePlanDown(folder.id, p.id),
                        onArchive: () => notifier.archivePlan(folder.id, p.id),
                        onDuplicate: () => notifier.duplicatePlan(folder.id, p.id),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final controller = TextEditingController();

                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.6),
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Neue Muskelgruppe",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: controller,
                                          cursorColor: Colors.white,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
                                            hintText: "Name eingeben",
                                            hintStyle: TextStyle(color: Colors.white38),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppTheme.primaryRed),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppTheme.primaryRed),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text("Abbrechen", style: TextStyle(color: Colors.white70)),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.primaryRed,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                final name = controller.text.trim();
                                                if (name.isEmpty) return;
                                                notifier.addPlan(folder.id, name);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Erstellen",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: const Text(
                          "+ Muskelgruppe hinzufügen",
                          style: TextStyle(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}