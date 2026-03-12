import 'package:flutter/material.dart';

class DashboardToggle extends StatelessWidget {
  const DashboardToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F35),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "PLÄNE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "ARCHIV",
                  style: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}