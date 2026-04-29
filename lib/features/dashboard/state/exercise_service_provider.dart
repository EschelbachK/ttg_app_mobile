import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/catalog_exercise_service.dart';
import '../../../core/network/dio_provider.dart';

final exerciseServiceProvider = Provider<ExerciseService>((ref) {
  return ExerciseService(ref.read(dioProvider));
});