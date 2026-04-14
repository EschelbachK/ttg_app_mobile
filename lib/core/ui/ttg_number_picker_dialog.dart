import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ttg_dialog_actions.dart';

Future<void> showTTGNumberPickerDialog({
  required BuildContext context,
  required String title,
  required int initialValue,
  required Function(int) onSubmit,
}) async {
  int selected = initialValue;

  await showDialog(
    context: context,
    builder: (c) => Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 40,
                    perspective: 0.003,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (i) => selected = i,
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (_, i) => Center(
                        child: Text(
                          "$i",
                          style: TextStyle(
                            color: i == selected
                                ? AppTheme.primaryRed
                                : Colors.white54,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      childCount: 201,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TTGDialogActions(
                  cancelText: "Abbrechen",
                  confirmText: "OK",
                  onCancel: () => Navigator.pop(c),
                  onConfirm: () {
                    onSubmit(selected);
                    Navigator.pop(c);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}