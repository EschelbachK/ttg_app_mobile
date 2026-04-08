import 'package:flutter/material.dart';

class TTGPlanCard extends StatelessWidget {
  final Widget child;
  final bool expanded;

  const TTGPlanCard({
    super.key,
    required this.child,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: expanded
            ? Colors.black.withOpacity(0.35)
            : Colors.transparent,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: child,
    );
  }
}