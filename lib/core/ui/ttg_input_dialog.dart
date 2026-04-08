import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

Future<void> showTTGInputDialog({
  required BuildContext context,
  required String title,
  required String buttonText,
  required Function(String) onSubmit,
  String initialValue = "",
}) async {
  final controller = TextEditingController(text: initialValue);

  await showDialog(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Eingeben...",
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: AppTheme.primaryRed),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text("Abbrechen",
                          style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        onSubmit(controller.text.trim());
                        Navigator.pop(c);
                      },
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}