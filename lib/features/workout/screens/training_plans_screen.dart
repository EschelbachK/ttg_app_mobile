import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';

class TrainingPlansScreen extends StatelessWidget {
  final String folderId;
  const TrainingPlansScreen({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Plans (Folder $folderId)',
      child: ListView(
        children: [
          ListTile(
            title: const Text('Plan X'),
            onTap: () => context.go('/folders/$folderId/plans/10/exercises'),
          ),
        ],
      ),
    );
  }
}