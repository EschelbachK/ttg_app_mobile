import 'package:flutter/material.dart';
import '../../domain/motivation_badge.dart';

class BadgeWidget extends StatelessWidget {
  final MotivationBadge badge;
  const BadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: badge.description,
      child: Chip(label: Text(badge.name)),
    );
  }
}