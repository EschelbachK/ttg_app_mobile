import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

Future<void> showTTGInputDialog({
  required BuildContext context,
  required String title,
  required String buttonText,
  String? initialValue,
  required Function(String value) onSubmit,
}) {
  final controller = TextEditingController(text: initialValue ?? '');

  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (dialogContext) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.85),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Name eingeben",
                    hintStyle:
                    TextStyle(color: Colors.white.withOpacity(0.4)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryRed),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryRed),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        "Abbrechen",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        final value = controller.text.trim();
                        if (value.isEmpty) return;

                        Navigator.pop(dialogContext);
                        onSubmit(value);
                      },
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}