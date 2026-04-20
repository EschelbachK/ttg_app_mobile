import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_provider.dart';
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktiviere den hellen Modus, wenn du im Freien trainierst oder die Sichtbarkeit erhöhen möchtest.',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: s.lightMode,
                      onChanged: (_) => n.toggleLightMode(),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(child: Text('Hellen Modus aktivieren')),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}