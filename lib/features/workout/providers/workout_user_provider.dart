import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutUserIdProvider = Provider<String>((ref) {
  // TODO später aus Auth ziehen
  return "test-user";
});