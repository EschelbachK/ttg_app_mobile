import 'package:flutter/material.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/side_drawer.dart';
import '../widgets/folder_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      body: Column(
        children: [
          const TopNavBar(),

          // Tabs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _tabButton("PLÄNE", true),
                const SizedBox(width: 12),
                _tabButton("ARCHIV", false),
              ],
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1DA1F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "Fortsetzen Schultern (V,S) - (3)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "MEINE TRAININGSPLÄNE",
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // List
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  FolderCard(title: "TAG 1 - PUSH - BRUST, TRIZEPS, SCHULTER(V,S)"),
                  SizedBox(height: 16),
                  FolderCard(title: "TAG 3 - PULL - RÜCKEN, BIZEPS, NACKEN, SCHULTER(H)"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1DA1F2) : const Color(0xFF2A3136),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(child: Text(label)),
      ),
    );
  }
}