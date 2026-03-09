import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1282A2),
        child: ListView(
          children: const [
            _Item(Icons.folder_copy, "TRAININGSPLÄNE"),
            _Item(Icons.fitness_center, "EIGENE ÜBUNGEN"),
            _Item(Icons.emoji_events, "ABSOLVIERTE EINHEITEN"),
            _Item(Icons.monitor_weight, "KÖRPERDATEN"),
            _Item(Icons.bar_chart, "STATISTIK"),
            _Item(Icons.settings, "EINSTELLUNGEN"),
            _Item(Icons.favorite, "UNTERSTÜTZE GAINSFIRE"),
            _Item(Icons.help, "HILFE"),
            _Item(Icons.school, "GAINSFIRE FÜR TRAINER"),
            _Item(Icons.info, "ÜBER GAINSFIRE"),
            _Item(Icons.logout, "LOGOUT"),
          ],
        ),
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
    );
  }
}