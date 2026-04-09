import 'package:dio/dio.dart';

class DashboardApi {
  final Dio dio;
  DashboardApi(this.dio);

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map) {
      final content = data['content'];
      if (content is List) return content;

      if (data.values.any((v) => v is List)) {
        return data.values.firstWhere((v) => v is List);
      }
    }

    return [];
  }

  Future<List<dynamic>> _getList(String path,
      {Map<String, dynamic>? query}) async {
    final res = await dio.get(path, queryParameters: query);
    return _extractList(res.data);
  }

  Future<List<dynamic>> getTrainingPlans() =>
      _getList('/training-plans');

  Future<List<dynamic>> getArchivedPlans() =>
      _getList('/training-plans/archived');

  Future<void> createTrainingPlan(String name) =>
      dio.post('/training-plans', data: {'title': name});

  Future<void> updateTrainingPlan(String planId, String name) =>
      dio.patch('/training-plans/$planId', data: {'title': name});

  Future<void> deleteTrainingPlan(String planId) =>
      dio.delete('/training-plans/$planId');

  Future<void> archiveTrainingPlan(String planId) =>
      dio.post('/training-plans/$planId/archive');

  Future<void> restoreTrainingPlan(String id) =>
      dio.patch('/training-plans/$id', data: {'archived': false});

  Future<List<dynamic>> getFolders(String planId) =>
      _getList('/training-plans/$planId/folders');

  Future<List<dynamic>> getArchivedFolders() =>
      _getList('/training-folders/archived');

  Future<void> createFolder({
    required String trainingPlanId,
    required String name,
    required int order,
  }) =>
      dio.post(
        '/training-plans/$trainingPlanId/folders',
        data: {'name': name, 'order': order},
      );

  Future<void> updateFolder({
    required String folderId,
    required String name,
  }) =>
      dio.patch(
        '/training-folders/$folderId',
        data: {'name': name},
      );

  Future<void> updateFolderOrder(String folderId, int order) =>
      dio.patch(
        '/training-folders/$folderId/order',
        queryParameters: {'order': order},
      );

  Future<void> deleteFolder(String folderId) =>
      dio.delete('/training-folders/$folderId');

  Future<void> duplicateFolder(String folderId) =>
      dio.post('/training-folders/$folderId/duplicate');

  Future<void> archiveFolder(String folderId) =>
      dio.post('/training-folders/$folderId/archive');

  Future<void> restoreFolder(String folderId) =>
      dio.patch('/training-folders/$folderId/restore');

  Future<List<dynamic>> getExercises({
    required String planId,
    required String folderId,
  }) =>
      _getList(
        '/training-plans/$planId/folders/$folderId/exercises',
      );

  Future<void> createExercise({
    required String planId,
    required String folderId,
    required String name,
    required String bodyRegion,
    required List<Map<String, dynamic>> sets,
  }) =>
      dio.post(
        '/training-plans/$planId/folders/$folderId/exercises',
        data: {
          'name': name,
          'bodyRegion': bodyRegion,
          'sets': sets,
        },
      );
}