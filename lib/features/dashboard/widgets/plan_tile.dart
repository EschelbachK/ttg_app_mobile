import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/training_plan.dart';
import '../state/dashboard_provider.dart';
import '../screens/muscle_group_screen.dart';

class PlanTile extends ConsumerWidget {

  final String folderId;
  final TrainingPlan plan;

  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onArchive;
  final VoidCallback onDuplicate;

  const PlanTile({
    super.key,
    required this.folderId,
    required this.plan,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onArchive,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF15181B),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Row(
          children: [

            Expanded(
              child: InkWell(

                borderRadius: BorderRadius.circular(12),

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MuscleGroupScreen(
                        folderId: folderId,
                        plan: plan,
                      ),
                    ),
                  );

                },

                child: Row(
                  children: [

                    const Icon(
                      Icons.fitness_center,
                      color: Color(0xFFFF3B30),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      plan.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// EDIT
                GestureDetector(

                  onTap: () {

                    final controller =
                    TextEditingController(text: plan.name);

                    showDialog(

                      context: context,
                      barrierDismissible: false,

                      builder: (_) => AlertDialog(

                        backgroundColor: const Color(0xFF161A1F),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        title: const Text(
                          "Muskelgruppe umbenennen",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),

                        content: TextField(

                          controller: controller,
                          autofocus: true,

                          style: const TextStyle(
                            color: Colors.white,
                          ),

                          decoration: const InputDecoration(

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

                        actions: [

                          TextButton(

                            onPressed: () {
                              context.pop();
                            },

                            child: const Text(
                              "Abbrechen",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),

                          ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFFFF3B30),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                            ),

                            onPressed: () {

                              final newName =
                              controller.text.trim();

                              if (newName.isEmpty) return;

                              notifier.renamePlan(
                                folderId,
                                plan.id,
                                newName,
                              );

                              context.pop();
                            },

                            child: const Text("Speichern"),
                          ),
                        ],
                      ),
                    );
                  },

                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.edit,
                      color: Color(0xFFFF3B30),
                      size: 18,
                    ),
                  ),
                ),

                /// DELETE
                GestureDetector(

                  onTap: () async {

                    final confirm = await showDialog<bool>(

                      context: context,

                      builder: (_) => AlertDialog(

                        backgroundColor: const Color(0xFF161A1F),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),

                        title: const Text(
                          "Muskelgruppe löschen?",
                          style: TextStyle(color: Colors.white),
                        ),

                        content: const Text(
                          "Möchtest du diese Muskelgruppe wirklich löschen?",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        actions: [

                          TextButton(

                            onPressed: () {
                              context.pop(false);
                            },

                            child: const Text(
                              "Abbrechen",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),

                          ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFFFF3B30),
                            ),

                            onPressed: () {
                              context.pop(true);
                            },

                            child: const Text("Löschen"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      onDelete();
                    }

                  },

                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.delete,
                      color: Color(0xFFFF3B30),
                      size: 18,
                    ),
                  ),
                ),

                /// MENU
                PopupMenuButton<String>(

                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white54,
                    size: 20,
                  ),

                  onSelected: (value) {

                    if (value == 'archive') onArchive();
                    if (value == 'duplicate') onDuplicate();
                    if (value == 'up') onMoveUp();
                    if (value == 'down') onMoveDown();
                    if (value == 'delete') onDelete();

                    if (value == 'move') {

                      showModalBottomSheet(

                        context: context,
                        backgroundColor:
                        const Color(0xFF1B1F23),

                        builder: (_) {

                          final otherFolders = state.folders
                              .where((f) => f.id != folderId)
                              .toList();

                          return ListView(

                            children: otherFolders.map((folder) {

                              return ListTile(

                                leading: const Icon(
                                  Icons.folder,
                                  color: Color(0xFFFF3B30),
                                ),

                                title: Text(
                                  folder.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),

                                onTap: () {

                                  notifier.movePlanToFolder(
                                    folderId,
                                    folder.id,
                                    plan.id,
                                  );

                                  context.pop();

                                },

                              );

                            }).toList(),

                          );

                        },

                      );

                    }

                  },

                  itemBuilder: (context) => const [

                    PopupMenuItem(
                      value: 'archive',
                      child: Text('Gruppe archivieren'),
                    ),

                    PopupMenuItem(
                      value: 'duplicate',
                      child: Text('Gruppe duplizieren'),
                    ),

                    PopupMenuItem(
                      value: 'move',
                      child: Text('In Ordner verschieben'),
                    ),

                    PopupMenuDivider(),

                    PopupMenuItem(
                      value: 'up',
                      child: Text('Nach oben'),
                    ),

                    PopupMenuItem(
                      value: 'down',
                      child: Text('Nach unten'),
                    ),

                    PopupMenuDivider(),

                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Löschen'),
                    ),

                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}