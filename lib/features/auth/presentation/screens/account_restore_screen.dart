import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AccountRestoreScreen extends StatelessWidget {
  const AccountRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(
                'Account deaktiviert',
                style: t.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Dein Account ist im 30 Tage Wiederherstellungsmodus.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: AppTheme.primaryButtonGradient,
                ),
                child: const Text(
                  'Account wiederherstellen',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}