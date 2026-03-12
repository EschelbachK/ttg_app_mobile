import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0E0F12),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Row(
        children: const [
          Icon(Icons.grid_view, color: Color(0xFFFF3B30)),
          SizedBox(width: 16),
          Icon(Icons.bar_chart, color: Colors.white38),
          SizedBox(width: 16),
          Icon(Icons.settings, color: Colors.white38),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text("Logout",
              style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}