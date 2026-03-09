import 'package:flutter/material.dart';

class PlanTile extends StatelessWidget {
  final String title;
  const PlanTile(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.fitness_center, color: Colors.lightBlue),
      title: Text(title),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {},
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'archive', child: Text('Plan archivieren')),
          PopupMenuItem(value: 'duplicate', child: Text('Plan duplizieren')),
          PopupMenuItem(value: 'move', child: Text('In Ordner verschieben')),
          PopupMenuItem(value: 'up', child: Text('Nach oben')),
          PopupMenuItem(value: 'down', child: Text('Nach unten')),
          PopupMenuItem(value: 'delete', child: Text('Löschen')),
        ],
      ),
    );
  }
}