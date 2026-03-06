import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_layout.dart';

class TrainingFoldersScreen extends StatelessWidget {
  const TrainingFoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Folders',
      child: ListView(
        children: [
          ListTile(
            title: const Text('Folder A'),
            onTap: () => context.go('/folders/1/plans'),
          ),
        ],
      ),
    );
  }
}
