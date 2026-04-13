import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TTGDialogActions extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const TTGDialogActions({
    super.key,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text(cancelText,
              style: const TextStyle(color: Colors.white70)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }
}