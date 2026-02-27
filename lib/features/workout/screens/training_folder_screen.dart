import 'package:flutter/material.dart';

class TrainingFolderScreen extends StatelessWidget {
  final String planId;
  final String planName;

  const TrainingFolderScreen({
    super.key,
    required this.planId,
    required this.planName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planName),
      ),
      body: Center(
        child: Text('Folders for Plan ID: $planId'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create Folder
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}