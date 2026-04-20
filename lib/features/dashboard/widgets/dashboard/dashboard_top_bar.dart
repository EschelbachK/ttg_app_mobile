import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_actions.dart';

class DashboardTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const DashboardTopBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

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
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: _TopBarIcons(
        selectedTab: selectedTab,
        onTabChanged: onTabChanged,
      ),
      actions: [
        TextButton.icon(
          onPressed: () => AuthActions.logout(ref, context),
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.white70),
          ),
        ),
      ],
    );
  }
}

class _TopBarIcons extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const _TopBarIcons({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _icon(context, Icons.grid_view, 0, const Color(0xFFFF3B30)),
        const SizedBox(width: 16),
        _icon(context, Icons.bar_chart, 2, Colors.redAccent),
        const SizedBox(width: 16),
        _icon(context, Icons.settings, 1, Colors.white),
      ],
    );
  }

  Widget _icon(BuildContext context, IconData icon, int index, Color activeColor) {
    final isActive = selectedTab == index;

    return GestureDetector(
      onTap: () {
        onTabChanged(index);
        if (index == 1) {
          context.push('/settings');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? activeColor.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isActive ? activeColor : Colors.white38,
          size: 22,
        ),
      ),
    );
  }
}