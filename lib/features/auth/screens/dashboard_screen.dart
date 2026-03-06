import 'package:flutter/material.dart';
import '../../../core/layout/app_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Dashboard",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Welcome Back",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "Your training overview will appear here.",
          ),
        ],
      ),
    );
  }
}