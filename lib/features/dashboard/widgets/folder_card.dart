import 'package:flutter/material.dart';
import 'plan_tile.dart';

class FolderCard extends StatelessWidget {
  final String title;
  const FolderCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A3136),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF30383E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(child: Text(title)),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const PlanTile("Brust (5)"),
          const PlanTile("Schultern (V,S) - (3)"),
          const PlanTile("Trizeps (5)"),
        ],
      ),
    );
  }
}