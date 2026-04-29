import 'package:dio/dio.dart';
import '../../features/dashboard/models/ranked_exercise_response.dart';
import '../../features/dashboard/models/training_exercise.dart';
import '../error/core_global_error_handler.dart';

class ExerciseService {
  final Dio dio;
  ExerciseService(this.dio);

  Future<TrainingExercise> createExercise(Map<String, dynamic> data) async {
    try {
      final res = await dio.post('/api/exercise/create', data: data);
      return TrainingExercise.fromJson(res.data);
    } catch (e) {
      throw GlobalErrorHandler.handle(e);
    }
  }

  Future<TrainingExercise> updateExercise(String id, Map<String, dynamic> data) async {
    try {
      final res = await dio.put('/api/exercise/update/$id', data: data);
      return TrainingExercise.fromJson(res.data);
    } catch (e) {
      throw GlobalErrorHandler.handle(e);
    }
  }

  Future<void> setExercise(String id, Map<String, dynamic> setEntry) async {
    try {
      await dio.put('/api/exercise/set/$id', data: setEntry);
    } catch (e) {
      throw GlobalErrorHandler.handle(e);
    }
  }

  Future<List<RankedExerciseResponse>> getRankedAlternatives(String exerciseId) async {
    try {
      final res = await dio.get('/api/exercise/ranked/$exerciseId');
      final list = List<Map<String, dynamic>>.from(res.data as List);
      return list.map((e) => RankedExerciseResponse.fromJson(e)).toList();
    } catch (e) {
      throw GlobalErrorHandler.handle(e);
    }
  }
}