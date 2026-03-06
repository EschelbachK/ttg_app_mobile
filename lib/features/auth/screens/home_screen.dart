import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/app_layout.dart';
import '../../../core/auth/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLayout(
      title: "Home",
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
        ),
      ],
      child: const Center(
        child: Text(
          "Welcome to TrainToGain",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}