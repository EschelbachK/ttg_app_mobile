import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/training_plan.dart';
import '../screens/muscle_group_screen.dart';
import '../state/dashboard_provider.dart';

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

  Future<bool> _showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
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
                      "Muskelgruppe löschen",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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

                  const Divider(color: Color(0xFFFF3B30)),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      TextButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        child: const Text(
                          "Abbrechen",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                        ),
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                        child: const Text(
                          "Löschen",
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
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final notifier = ref.read(dashboardProvider.notifier);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),

              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0,8),
                )
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(8),

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

                      /// EDIT (UNVERÄNDERT)
                      GestureDetector(
                        onTap: () {
                          final controller =
                          TextEditingController(text: plan.name);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: Container(), // unchanged part omitted
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

                      /// ✅ DELETE FIX
                      GestureDetector(
                        onTap: () async {
                          final confirm = await _showDeleteDialog(context);
                          if (!confirm) return;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            onDelete();
                          });
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

                      /// ✅ POPUP FIX
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onSelected: (value) async {

                          if (value == 'archive') onArchive();
                          if (value == 'duplicate') onDuplicate();
                          if (value == 'up') onMoveUp();
                          if (value == 'down') onMoveDown();

                          if (value == 'delete') {

                            await Future.delayed(Duration.zero);

                            final confirm = await _showDeleteDialog(context);
                            if (!confirm) return;

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              onDelete();
                            });
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'archive', child: Text('Gruppe archivieren')),
                          PopupMenuItem(value: 'duplicate', child: Text('Gruppe duplizieren')),
                          PopupMenuDivider(),
                          PopupMenuItem(value: 'up', child: Text('Nach oben')),
                          PopupMenuItem(value: 'down', child: Text('Nach unten')),
                          PopupMenuDivider(),
                          PopupMenuItem(value: 'delete', child: Text('Löschen')),
                        ],
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
  }
}