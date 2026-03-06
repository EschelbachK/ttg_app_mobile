import 'package:flutter/material.dart';
import '../../../core/layout/app_layout.dart';
import '../../workout/screens/training_plans_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Dashboard",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome Back",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text("Your training overview will appear here."),
          const SizedBox(height: 24),

          ElevatedButton(
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
        ],
      ),
    );
  }
}