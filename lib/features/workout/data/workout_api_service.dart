import 'package:dio/dio.dart';
import '../../dashboard/models/training_plan.dart';
import '../../dashboard/models/training_folder.dart';
import '../models/set_entry.dart';
import '../models/training_exercise.dart';

class WorkoutApiService {
  final Dio _dio;

  WorkoutApiService(this._dio);

  List<dynamic> _extract(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['content'] is List) {
      return List<dynamic>.from(data['content']);
    }
    if (data is Map && data['data'] is List) {
      return List<dynamic>.from(data['data']);
    }
    return [];
  }

  Future<List<T>> _mapList<T>(
      String path,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    final res = await _dio.get(path);
    final list = _extract(res.data);
    return list.map((e) => fromJson(e)).toList();
  }

  Future<List<TrainingPlan>> getTrainingPlans() =>
      _mapList('/training-plans', TrainingPlan.fromJson);

  Future<List<TrainingFolder>> getFolders(String planId) =>
      _mapList('/training-plans/$planId/folders',
          TrainingFolder.fromJson);

  Future<List<TrainingExercise>> getExercises(String folderId) =>
      _mapList('/folders/$folderId/exercises',
          TrainingExercise.fromJson);

  Future<List<SetEntry>> getSets(String exerciseId) =>
      _mapList('/exercises/$exerciseId/sets',
          SetEntry.fromJson);

  Future<SetEntry> updateSet(
      String exerciseId,
      String setId,
      int reps,
      double weight,
      bool completed,
      ) async {
    final res = await _dio.put(
      '/exercises/$exerciseId/sets/$setId',
      data: {
        'reps': reps,
        'weight': weight,
        'completed': completed,
      },
    );
    return SetEntry.fromJson(res.data);
  }
}