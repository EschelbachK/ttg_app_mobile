import 'package:flutter/material.dart';

extension BodyRegionUI on String {
  String get bodyRegionLabel {
    switch (this) {
      case 'BRUST':
        return 'Brust';
      case 'RUECKEN':
        return 'Rücken';
      case 'BEINE':
        return 'Beine';
      case 'SCHULTERN':
        return 'Schultern';
      case 'ARME':
        return 'Arme';
      case 'CORE':
        return 'Core';
      default:
        return this;
    }
  }

  IconData get bodyRegionIcon {
    switch (this) {
      case 'BRUST':
        return Icons.fitness_center;
      case 'RUECKEN':
        return Icons.accessibility_new;
      case 'BEINE':
        return Icons.directions_run;
      case 'SCHULTERN':
        return Icons.pan_tool;
      case 'ARME':
        return Icons.sports_mma;
      case 'CORE':
        return Icons.self_improvement;
      default:
        return Icons.circle;
    }
  }

  Color get bodyRegionColor {
    switch (this) {
      case 'BRUST':
        return Colors.red;
      case 'RUECKEN':
        return Colors.blue;
      case 'BEINE':
        return Colors.green;
      case 'SCHULTERN':
        return Colors.orange;
      case 'ARME':
        return Colors.purple;
      case 'CORE':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}