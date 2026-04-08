import 'package:dio/dio.dart';
import '../../dashboard/models/training_plan.dart';
import '../../dashboard/models/training_folder.dart';
import '../models/set_entry.dart';
import '../models/training_exercise.dart';

class WorkoutApiService {
  final Dio _dio;

  WorkoutApiService(this._dio);

  Future<List<T>> _mapList<T>(
      String path,
      T Function(Map<String, dynamic>) fromJson) async {
    final res = await _dio.get(path);
    final data = res.data as List<dynamic>;
    return data.map((e) => fromJson(e)).toList();
  }

  Future<List<TrainingPlan>> getTrainingPlans() =>
      _mapList('/training-plans', TrainingPlan.fromJson);

  Future<TrainingPlan> createTrainingPlan(String name) async {
    final res =
    await _dio.post('/training-plans', data: {'name': name});
    return TrainingPlan.fromJson(res.data);
  }

  Future<void> deleteTrainingPlan(String id) =>
      _dio.delete('/training-plans/$id');

  Future<List<TrainingFolder>> getFolders(String planId) =>
      _mapList(
          '/training-plans/$planId/folders',
          TrainingFolder.fromJson);

  Future<TrainingFolder> createFolder(
      String planId, String name) async {
    final res = await _dio.post(
      '/training-plans/$planId/folders',
      data: {'name': name},
    );
    return TrainingFolder.fromJson(res.data);
  }

  Future<void> deleteFolder(String planId, String folderId) =>
      _dio.delete('/training-plans/$planId/folders/$folderId');

  Future<List<TrainingExercise>> getExercises(String folderId) =>
      _mapList(
          '/folders/$folderId/exercises',
          TrainingExercise.fromJson);

  Future<List<SetEntry>> getSets(String exerciseId) =>
      _mapList(
          '/exercises/$exerciseId/sets',
          SetEntry.fromJson);

  Future<SetEntry> updateSet(
      String exerciseId,
      String setId,
      int reps,
      double weight,
      bool completed) async {
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