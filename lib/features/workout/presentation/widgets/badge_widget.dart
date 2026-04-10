import 'package:flutter/material.dart';
import '../../domain/motivation/motivation_badge.dart';

class BadgeWidget extends StatelessWidget {
  final MotivationBadge badge;

  const BadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: badge.description,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          badge.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}