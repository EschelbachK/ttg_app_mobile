import 'package:flutter/material.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1282A2),
      child: ListView(
        children: const [
          _Item(Icons.folder_copy, "Trainingspläne"),
          _Item(Icons.fitness_center, "Eigene Übungen"),
          _Item(Icons.emoji_events, "Absolvierte Einheiten"),
          _Item(Icons.monitor_weight, "Körperdaten"),
          _Item(Icons.bar_chart, "Statistik"),
          _Item(Icons.settings, "Einstellungen"),
          _Item(Icons.favorite, "Unterstütze Gainsfire"),
          _Item(Icons.help, "Hilfe"),
          _Item(Icons.school, "Gainsfire für Trainer"),
          _Item(Icons.info, "Über Gainsfire"),
          Divider(),
          _Item(Icons.logout, "Logout"),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Item(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}