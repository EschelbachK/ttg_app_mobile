import 'package:flutter/material.dart';
import '../../../core/layout/app_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Dashboard',
      child: Center(
        child: Text(
          'DASHBOARD OK',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}