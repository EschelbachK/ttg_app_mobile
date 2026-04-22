import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ttg_app_mobile/features/settings/presentation/widgets/weight_step.dart';
import '../../../../core/settings/settings_controller.dart';
import 'settings_bottom_sheets.dart';
import 'settings_tile.dart';

class WeightStepExpand extends ConsumerWidget {
  const WeightStepExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final t = Theme.of(context);

    return SettingsTile(
      icon: Icons.fitness_center,
      title: 'Gewichtsschritte',
      onTap: () => showWeightStepSheet(context, s, n),
      trailing: Text(
        WeightStep.label(s.weightStep),
        style: TextStyle(
          color: t.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}