import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../data/workout_api_service.dart';
import '../models/training_plan.dart';

/// Dio provider (falls noch nicht global vorhanden)
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

/// Workout API Service Provider
final workoutApiServiceProvider = Provider<WorkoutApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return WorkoutApiService(dio);
});

/// Fetch Training Plans
final trainingPlansProvider =
FutureProvider<List<TrainingPlan>>((ref) async {
  final api = ref.watch(workoutApiServiceProvider);
  return api.getTrainingPlans();
});