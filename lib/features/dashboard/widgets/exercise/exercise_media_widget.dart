import 'package:flutter/material.dart';
import '../../../catalog/models/exercise_detail_model.dart';

class ExerciseMediaWidget extends StatelessWidget {
  final ExerciseMedia? media;

  const ExerciseMediaWidget({super.key, this.media});

  @override
  Widget build(BuildContext context) {
    final img = media?.image ?? 'assets/images/placeholder.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: img.startsWith('http')
          ? Image.network(img, fit: BoxFit.cover)
          : Image.asset(img, fit: BoxFit.cover),
    );
  }
}