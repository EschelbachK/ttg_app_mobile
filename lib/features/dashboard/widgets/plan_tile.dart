import 'package:flutter/material.dart';

class PlanTile extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;

  const PlanTile({
    super.key,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF15181B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Color(0xFFFF3B30)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white54),
          onSelected: (v) {
            if (v == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'archive', child: Text('Plan archivieren')),
            PopupMenuItem(value: 'duplicate', child: Text('Plan duplizieren')),
            PopupMenuItem(value: 'move', child: Text('In Ordner verschieben')),
            PopupMenuItem(value: 'up', child: Text('Nach oben')),
            PopupMenuItem(value: 'down', child: Text('Nach unten')),
            PopupMenuItem(value: 'delete', child: Text('Löschen')),
          ],
        ),
      ),
    );
  }
}