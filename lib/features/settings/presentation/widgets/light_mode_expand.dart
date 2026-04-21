import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/settings/settings_controller.dart';
import 'settings_tile.dart';

class LightModeExpand extends ConsumerWidget {
  const LightModeExpand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);

    return Column(
      children: [
        SettingsTile(
          icon: Icons.lightbulb_outline,
          title: 'Heller Modus',
          value: s.lightMode,
          onChanged: (_) => n.toggleLightMode(),
          expandable: true,
          isExpanded: s.lightExpanded,
          onTap: n.toggleLightExpanded,
        ),
        if (s.lightExpanded)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 8, 10),
            child: Text(
              'Nutze den hellen Modus für bessere Sichtbarkeit bei Tageslicht oder im Freien.',
              style: TextStyle(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}