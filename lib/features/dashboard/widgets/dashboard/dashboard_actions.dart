import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../utils/dashboard_plan_dialog.dart';

class DashboardActions extends ConsumerWidget {
  const DashboardActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryRed,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withOpacity(0.5),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Neuen Plan erstellen"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 32,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: () =>
                DashboardPlanDialog.showCreate(context, ref),
          ),
        ),
      ),
    );
  }
}