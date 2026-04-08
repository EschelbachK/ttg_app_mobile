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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppTheme.primaryRed,
                  onSubmitted: (v) {
                    final text = v.trim();
                    if (text.isEmpty) return;
                    onSubmit(text);
                    Navigator.pop(c);
                  },
                  decoration: InputDecoration(
                    hintText: "Eingeben...",
                    hintStyle:
                    const TextStyle(color: Colors.white38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppTheme.primaryRed, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text("Abbrechen",
                          style:
                          TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        onSubmit(text);
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