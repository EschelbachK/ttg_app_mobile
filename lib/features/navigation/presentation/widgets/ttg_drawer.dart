import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../settings/presentation/widgets/settings_tile.dart';
import '../../application/navigation_provider.dart';

class TtgDrawer extends ConsumerWidget {
  const TtgDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navigationProvider);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: kToolbarHeight + 60,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item(context, ref, nav, 0, Icons.folder, 'Trainingspläne', '/'),
                      _item(context, ref, nav, 1, Icons.add, 'Eigene Übungen', '/exercises'),
                      _item(context, ref, nav, 2, Icons.emoji_events, 'Einheiten', '/sessions'),
                      _item(context, ref, nav, 3, Icons.monitor_weight, 'Körperdaten', '/body'),
                      _item(context, ref, nav, 4, Icons.bar_chart, 'Statistik', '/stats'),
                      _item(context, ref, nav, 5, Icons.settings, 'Einstellungen', '/settings'),
                      _item(
                        context,
                        ref,
                        nav,
                        99,
                        Icons.logout,
                        'Logout',
                        '/login',
                        danger: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context,
      WidgetRef ref,
      int active,
      int index,
      IconData icon,
      String title,
      String route, {
        bool danger = false,
      }) {
    final isActive = active == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      child: SettingsTile(
        icon: icon,
        title: title,
        onTap: () {
          ref.read(navigationProvider.notifier).state = index;
          Navigator.pop(context);
          context.go(route);
        },
        trailing: isActive
            ? Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: danger ? Colors.red : AppTheme.primaryRed,
            shape: BoxShape.circle,
          ),
        )
            : null,
      ),
    );
  }
}