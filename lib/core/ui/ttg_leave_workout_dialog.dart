import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ttg_app_mobile/core/ui/ttg_dialog_actions.dart';
import '../theme/app_theme.dart';

Future<String?> showTTGLeaveWorkoutDialog({
  required BuildContext context,
}) async {
  return showDialog<String>(
    context: context,
    builder: (c) => Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Workout verlassen?",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Was möchtest du tun?",
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 20),
                const Divider(color: AppTheme.primaryRed),
                const SizedBox(height: 24),
                TTGDialogActions(
                  cancelText: "Pausieren",
                  confirmText: "Beenden",
                  onCancel: () => Navigator.pop(c, "pause"),
                  onConfirm: () => Navigator.pop(c, "finish"),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}