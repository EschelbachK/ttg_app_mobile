import 'package:flutter/material.dart';
import '../../workout/screens/training_plans_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TrainingPlansScreen(),
              ),
            );
          },
          child: const Text("Meine Trainingspläne"),
        ),
      ),
    );
  }
}