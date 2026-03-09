import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const Icon(Icons.folder_copy_outlined),
            const SizedBox(width: 16),
            const Icon(Icons.bar_chart_outlined),
            const SizedBox(width: 16),
            const Icon(Icons.settings_outlined),
            const Spacer(),
            const Icon(Icons.hexagon_outlined),
          ],
        ),
      ),
    );
  }
}