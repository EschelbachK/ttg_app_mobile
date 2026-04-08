import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/ttg_glow_border.dart';
import '../../../../core/theme/app_theme.dart';
import '../../state/dashboard_provider.dart';
import '../../utils/dashboard_toggle_config.dart';

class DashboardToggle extends ConsumerWidget {
  const DashboardToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TTGGlowBorder(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: DashboardToggleConfig.items
                    .map((item) => Expanded(
                  child: GestureDetector(
                    onTap: item.isArchive
                        ? notifier.showArchive
                        : notifier.showPlans,
                    child: Container(
                      decoration: BoxDecoration(
                        color: state.showArchive ==
                            item.isArchive
                            ? AppTheme.primaryRed
                            : Colors.transparent,
                        borderRadius:
                        BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}