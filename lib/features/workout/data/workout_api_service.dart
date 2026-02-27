import 'package:dio/dio.dart';

import '../models/training_plan.dart';
import '../models/training_folder.dart';
import '../models/training_exercise.dart';

class WorkoutApiService {
  final Dio _dio;

  WorkoutApiService(this._dio);

  // =========================
  // TRAINING PLAN
  // =========================

  Future<List<TrainingPlan>> getTrainingPlans() async {
    final response = await _dio.get('/training-plans');
    final data = response.data as List<dynamic>;

    return data
        .map((json) => TrainingPlan.fromJson(json))
        .toList();
  }

  Future<TrainingPlan> createTrainingPlan(String name) async {
    final response = await _dio.post(
      '/training-plans',
      data: {'name': name},
    );

    return TrainingPlan.fromJson(response.data);
  }

  Future<void> deleteTrainingPlan(String id) async {
    await _dio.delete('/training-plans/$id');
  }

  // =========================
  // TRAINING FOLDER
  // =========================

  Future<List<TrainingFolder>> getFolders(String planId) async {
    final response =
    await _dio.get('/training-plans/$planId/folders');

    final data = response.data as List<dynamic>;

    return data
        .map((json) => TrainingFolder.fromJson(json))
        .toList();
  }

  Future<TrainingFolder> createFolder(
      String planId, String name) async {
    final response = await _dio.post(
      '/training-plans/$planId/folders',
      data: {'name': name},
    );

    return TrainingFolder.fromJson(response.data);
  }

  Future<void> deleteFolder(
      String planId, String folderId) async {
    await _dio.delete(
        '/training-plans/$planId/folders/$folderId');
  }

  // =========================
  // TRAINING EXERCISE
  // =========================

  Future<List<TrainingExercise>> getExercises(
      String folderId) async {
    final response =
    await _dio.get('/folders/$folderId/exercises');

    final data = response.data as List<dynamic>;

    return data
        .map((json) => TrainingExercise.fromJson(json))
        .toList();
  }

  Future<TrainingExercise> createExercise(
      String folderId, String name) async {
    final response = await _dio.post(
      '/folders/$folderId/exercises',
      data: {'name': name},
    );

    return TrainingExercise.fromJson(response.data);
  }

  Future<void> deleteExercise(
      String folderId, String exerciseId) async {
    await _dio.delete(
        '/folders/$folderId/exercises/$exerciseId');
  }
}