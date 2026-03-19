import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_folder.dart';
import '../screens/muscle_group_screen.dart';
import '../state/dashboard_provider.dart';

class ArchivedFolderTile extends ConsumerStatefulWidget {

  final TrainingFolder folder;

  const ArchivedFolderTile({
    super.key,
    required this.folder,
  });

  @override
  ConsumerState<ArchivedFolderTile> createState() =>
      _ArchivedFolderTileState();
}

class _ArchivedFolderTileState
    extends ConsumerState<ArchivedFolderTile> {

  bool expanded = false;

  @override
  Widget build(BuildContext context) {

    final folder = widget.folder;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 HEADER
          Row(
            children: [

              /// 🔥 GANZER LINKER BEREICH IST KLICKBAR
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: Row(
                    children: [

                      const Icon(
                        Icons.folder,
                        color: Color(0xFFFF3B30),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          folder.name,
                          style: const TextStyle(
                            color: Colors.white,
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
                    ],
                  ),
                ),
              ),

              /// 🔥 IMPORT BUTTON BLEIBT SEPARAT
              IconButton(
                icon: const Icon(
                  Icons.file_download,
                  color: Color(0xFFFF3B30),
                ),
                onPressed: () {
                  ref
                      .read(dashboardProvider.notifier)
                      .importFolder(folder);
                },
              ),
            ],
          ),

          /// 🔥 EXPANDED CONTENT
          if (expanded) ...[

            const SizedBox(height: 10),

            ...folder.plans.map((plan) {

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),

                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MuscleGroupScreen(
                          folderId: "archived",
                          plan: plan,
                          isArchived: true,
                        ),
                      ),
                    );
                  },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      plan.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}