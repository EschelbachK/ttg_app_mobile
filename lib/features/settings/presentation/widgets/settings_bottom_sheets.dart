import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/settings_provider.dart';

Widget _glassContainer(BuildContext context, Widget child) {
  final t = Theme.of(context);
  final isDark = t.brightness == Brightness.dark;

  Widget content = Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: isDark ? null : Colors.white,
      gradient: isDark
          ? LinearGradient(
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.02),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )
          : null,
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.06),
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.4)
              : Colors.black.withOpacity(0.08),
          blurRadius: 25,
          spreadRadius: -8,
        ),
      ],
    ),
    child: child,
  );

  return ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: isDark
        ? BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
      child: content,
    )
        : content,
  );
}

Widget _saveButton(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: -8,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryRed.withOpacity(0.9),
            AppTheme.primaryRed,
          ],
        ),
      ),
      child: const Text(
        'SPEICHERN',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    ),
  );
}

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
            child: _glassContainer(
              context,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SATZPAUSE', style: t.textTheme.bodySmall),
                  const SizedBox(height: 10),
                  Text('$temp SEKUNDEN', style: t.textTheme.titleLarge),
                  Slider(
                    value: temp.toDouble(),
                    min: 10,
                    max: 180,
                    activeColor: AppTheme.primaryRed,
                    inactiveColor: Colors.grey.withOpacity(0.2),
                    thumbColor: AppTheme.primaryRed,
                    overlayColor: WidgetStateProperty.all(
                      AppTheme.primaryRed.withOpacity(0.15),
                    ),
                    onChanged: (v) => set(() => temp = v.toInt()),
                  ),
                  const SizedBox(height: 10),
                  _saveButton(() {
                    n.setRestTimer(temp);
                    Navigator.pop(context);
                  }),
                ],
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
            child: _glassContainer(
              context,
              Column(
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
                    inactiveColor: Colors.grey.withOpacity(0.2),
                    thumbColor: AppTheme.primaryRed,
                    overlayColor: WidgetStateProperty.all(
                      AppTheme.primaryRed.withOpacity(0.15),
                    ),
                    onChanged: (v) => set(() => temp = v),
                  ),
                  const SizedBox(height: 10),
                  _saveButton(() {
                    n.setFontScale(temp);
                    Navigator.pop(context);
                  }),
                ],
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
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _glassContainer(
          context,
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Account löschen bestätigen'),
          ),
        ),
      );
    },
  );
}