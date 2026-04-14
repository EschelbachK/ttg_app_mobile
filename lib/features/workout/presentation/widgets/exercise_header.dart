import 'package:flutter/material.dart';

const kPrimaryRed = Color(0xFFE10600);

class ExerciseHeader extends StatelessWidget {
  final String title;

  const ExerciseHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 16, height: 2, color: kPrimaryRed),
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
        Container(width: 16, height: 2, color: kPrimaryRed),
      ],
    );
  }
}