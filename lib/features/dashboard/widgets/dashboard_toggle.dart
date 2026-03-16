import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/lib/core/ui/ttg_glow_border.dart';
import '../state/dashboard_provider.dart';

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
                children: [

                  Expanded(
                    child: GestureDetector(
                      onTap: notifier.showPlans,

                      child: Container(
                        decoration: BoxDecoration(
                          color: !state.showArchive
                              ? const Color(0xFFFF3B30)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),

                        alignment: Alignment.center,

                        child: const Text(
                          "PLÄNE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      onTap: notifier.showArchive,

                      child: Container(
                        decoration: BoxDecoration(
                          color: state.showArchive
                              ? const Color(0xFFFF3B30)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),

                        alignment: Alignment.center,

                        child: const Text(
                          "ARCHIV",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}