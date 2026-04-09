import 'motivation_type.dart';
import 'motivation_level.dart';

class MotivationResult {
  final MotivationType type;
  final MotivationLevel level;
  final String message;

  const MotivationResult({
    required this.type,
    required this.level,
    required this.message,
  });
}