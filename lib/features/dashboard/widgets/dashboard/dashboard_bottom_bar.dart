import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/dashboard_provider.dart';
import '../../utils/dashboard_dialogs.dart';

class DashboardBottomBar extends ConsumerWidget {
  final String planId;

  const DashboardBottomBar({
    super.key,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dashboardProvider.notifier);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => DashboardDialogs.createFolder(
                    context,
                    notifier,
                    planId,
                  ),
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text("ORDNER"),
                  style: _style(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("PLAN"),
                  style: _style(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _style() => ElevatedButton.styleFrom(
    backgroundColor: Colors.white.withOpacity(0.08),
    foregroundColor: const Color(0xFFFF3B30),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  );
}