import 'package:flutter/material.dart';
import '../models/training_plan.dart';
import '../screens/muscle_group_screen.dart';

class PlanTile extends StatelessWidget {

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
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: const Color(0xFF15181B),
        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(

        leading: const Icon(
          Icons.fitness_center,
          color: Color(0xFFFF3B30),
        ),

        title: Text(
          plan.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),

        /// 🔴 HIER IST DIE NEUE NAVIGATION
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

        trailing: PopupMenuButton<String>(

          icon: const Icon(Icons.more_vert, color: Colors.white54),

          onSelected: (value) {

            if (value == 'archive') onArchive();

            if (value == 'duplicate') onDuplicate();

            if (value == 'up') onMoveUp();

            if (value == 'down') onMoveDown();

            if (value == 'delete') onDelete();
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
      ),
    );
  }
}