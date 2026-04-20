import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/settings_provider.dart';

void showRestTimerSheet(BuildContext context, SettingsState s, SettingsNotifier n) {
  int temp = s.restTimerSeconds;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (_, set) {
          final t = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('SATZPAUSE', style: t.textTheme.bodySmall),
                      const SizedBox(height: 10),
                      Text('$temp SEKUNDEN', style: t.textTheme.titleLarge),
                      Slider(
                        value: temp.toDouble(),
                        min: 10,
                        max: 180,
                        divisions: 17,
                        activeColor: AppTheme.primaryRed,
                        onChanged: (v) => set(() => temp = v.toInt()),
                      ),
                      GestureDetector(
                        onTap: () {
                          n.setRestTimer(temp);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primaryRed),
                          ),
                          child: const Text('SPEICHERN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showFontScaleSheet(BuildContext context, SettingsState s, SettingsNotifier n) {
  double temp = s.fontScale;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (_, set) {
          final t = Theme.of(context);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('SCHRIFTGRÖSSE', style: t.textTheme.bodySmall),
                      const SizedBox(height: 10),
                      Text('${temp.toStringAsFixed(1)}x', style: t.textTheme.titleLarge),
                      Slider(
                        value: temp,
                        min: 0.8,
                        max: 1.5,
                        activeColor: AppTheme.primaryRed,
                        onChanged: (v) => set(() => temp = v),
                      ),
                      GestureDetector(
                        onTap: () {
                          n.setFontScale(temp);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primaryRed),
                          ),
                          child: const Text('SPEICHERN'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showDeleteAccountSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Account löschen bestätigen'),
      );
    },
  );
}