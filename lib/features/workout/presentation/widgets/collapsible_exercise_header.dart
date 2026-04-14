import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class CollapsibleExerciseHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final bool allDone;
  final VoidCallback onTap;

  const CollapsibleExerciseHeader({
    super.key,
    required this.title,
    required this.expanded,
    required this.allDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.white54,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 12, height: 2, color: kPrimaryRed),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(width: 12, height: 2, color: kPrimaryRed),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (allDone)
              Row(
                children: const [
                  Icon(Icons.check, color: kPrimaryRed, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "Erledigt!",
                    style: TextStyle(
                      color: kPrimaryRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }
}