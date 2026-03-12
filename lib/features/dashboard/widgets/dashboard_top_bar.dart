import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';

class DashboardTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const DashboardTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          },
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}