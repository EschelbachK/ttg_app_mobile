import 'package:flutter/material.dart';
import '../../utils/dashboard_drawer_items.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1282A2),
      child: ListView(
        children: [
          ...DashboardDrawerItems.items
              .map((e) => _Item(e.icon, e.label)),
          const Divider(),
          const _Item(Icons.logout, "Logout"),
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
      title:
      Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}