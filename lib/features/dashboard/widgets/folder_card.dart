import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/lib/core/ui/ttg_glow_border.dart';
import '../models/training_folder.dart';
import '../state/dashboard_provider.dart';
import 'plan_tile.dart';

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TTGGlowBorder(

        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),

          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
            ),

            child: Container(

              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),

              child: Column(
                children: [

                  /// HEADER
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.folder,
                            color: Color(0xFFFF3B30),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              folder.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),

                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white54,
                            ),

                            onSelected: (value) {

                              if (value == 'archive') {
                                notifier.archiveFolder(folder.id);
                              }

                              if (value == 'delete') {
                                notifier.deleteFolder(folder.id);
                              }

                            },

                            itemBuilder: (context) => const [

                              PopupMenuItem(
                                value: 'archive',
                                child: Text("Plan archivieren"),
                              ),

                              PopupMenuItem(
                                value: 'delete',
                                child: Text("Plan löschen"),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  /// MUSCLE GROUP LIST
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

                    /// ADD MUSCLE GROUP
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
                                  filter: ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),

                                  child: Container(
                                    padding: const EdgeInsets.all(20),

                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),

                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Neue Muskelgruppe",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        TextField(

                                          controller: controller,
                                          autofocus: false,
                                          cursorColor: Colors.white,

                                          style: const TextStyle(color: Colors.white),

                                          decoration: const InputDecoration(

                                            hintText: "Name eingeben",
                                            hintStyle: TextStyle(color: Colors.white38),

                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF3B30),
                                              ),
                                            ),

                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF3B30),
                                              ),
                                            ),

                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [

                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text(
                                                "Abbrechen",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            ElevatedButton(

                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFF3B30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
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
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
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
                            color: Color(0xFFFF3B30),
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