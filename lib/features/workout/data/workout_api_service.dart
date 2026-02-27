import 'package:dio/dio.dart';
import '../models/training_plan.dart';

class WorkoutApiService {
  final Dio _dio;

  WorkoutApiService(this._dio);

  /// GET all training plans
  Future<List<TrainingPlan>> getTrainingPlans() async {
    final response = await _dio.get('/training-plans');

    final data = response.data as List<dynamic>;

    return data
        .map((json) => TrainingPlan.fromJson(json))
        .toList();
  }

  /// CREATE training plan
  Future<TrainingPlan> createTrainingPlan(String name) async {
    final response = await _dio.post(
      '/training-plans',
      data: {
        'name': name,
      },
    );

    return TrainingPlan.fromJson(response.data);
  }

  /// DELETE training plan
  Future<void> deleteTrainingPlan(String id) async {
    await _dio.delete('/training-plans/$id');
  }
}