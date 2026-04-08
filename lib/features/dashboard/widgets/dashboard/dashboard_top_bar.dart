import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/auth_actions.dart';

class DashboardTopBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const DashboardTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: const Color(0xFF1B1F23),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white38),
          onPressed: () =>
              Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const _TopBarIcons(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton.icon(
            onPressed: () =>
                AuthActions.logout(ref, context),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: const ButtonStyle(
              foregroundColor:
              MaterialStatePropertyAll(Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBarIcons extends StatelessWidget {
  const _TopBarIcons();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.grid_view, color: Color(0xFFFF3B30)),
        SizedBox(width: 16),
        Icon(Icons.bar_chart, color: Colors.white38),
        SizedBox(width: 16),
        Icon(Icons.settings, color: Colors.white38),
      ],
    );
  }
}