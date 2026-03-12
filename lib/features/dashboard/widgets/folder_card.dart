import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_folder.dart';
import '../state/dashboard_provider.dart';
import 'plan_tile.dart';

class FolderCard extends ConsumerWidget {
  final TrainingFolder folder;

  const FolderCard({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B1F23), Color(0xFF121416)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x33FF3B30)),
      ),

      child: Column(
        children: [

          /// PLAN HEADER
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              color: Color(0xFF20252A),
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
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white54),

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

          ...folder.plans.map(
                (p) => PlanTile(
              folderId: folder.id,
              plan: p,
              onDelete: () => notifier.deletePlan(folder.id, p.id),
              onMoveUp: () {},
              onMoveDown: () {},
              onArchive: () => notifier.archivePlan(folder.id, p.id),
              onDuplicate: () {},
            ),
          ),

          InkWell(
            onTap: () {
              final controller = TextEditingController();

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF1B1F23),
                    title: const Text(
                      "Neue Muskelgruppe",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                    ),
                    actions: [

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Abbrechen"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          notifier.addPlan(folder.id, controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Erstellen"),
                      )
                    ],
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
      ),
    );
  }
}