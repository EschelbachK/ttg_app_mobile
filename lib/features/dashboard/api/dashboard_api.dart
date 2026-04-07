import 'package:dio/dio.dart';

class DashboardApi {
  final Dio dio;

  DashboardApi(this.dio);

  Future<List<dynamic>> _extractList(dynamic data) {
    if (data is List) return Future.value(data);
    if (data is Map && data['content'] is List) {
      return Future.value(List<dynamic>.from(data['content']));
    }
    return Future.value([]);
  }

  Future<List<dynamic>> getTrainingPlans() async {
    final res = await dio.get('/training-plans');
    return _extractList(res.data);
  }

  Future<List<dynamic>> getArchivedPlans() async {
    final res = await dio.get('/training-plans/archived');
    return _extractList(res.data);
  }

  Future<void> createTrainingPlan(String name) async {
    await dio.post('/training-plans', data: {'title': name});
  }

  Future<void> updateTrainingPlan(String planId, String name) async {
    await dio.patch('/training-plans/$planId', data: {'title': name});
  }

  Future<void> deleteTrainingPlan(String planId) async {
    await dio.delete('/training-plans/$planId');
  }

  Future<void> archiveTrainingPlan(String planId) async {
    await dio.post('/training-plans/$planId/archive');
  }

  Future<List<dynamic>> getFolders(String planId) async {
    final res = await dio.get('/training-plans/$planId/folders');
    return _extractList(res.data);
  }

  Future<List<dynamic>> getArchivedFolders() async {
    final res = await dio.get('/training-folders/archived');
    return _extractList(res.data);
  }

  Future<void> createFolder({
    required String trainingPlanId,
    required String name,
    required int order,
  }) async {
    await dio.post(
      '/training-plans/$trainingPlanId/folders',
      data: {
        'name': name,
        'order': order,
      },
    );
  }

  Future<void> updateFolder({
    required String folderId,
    required String name,
  }) async {
    await dio.patch(
      '/training-folders/$folderId',
      data: {'name': name},
    );
  }

  Future<void> updateFolderOrder(
      String folderId,
      int order,
      ) async {
    await dio.patch(
      '/training-folders/$folderId/order',
      queryParameters: {'order': order},
    );
  }

  Future<void> deleteFolder(String folderId) async {
    await dio.delete('/training-folders/$folderId');
  }

  Future<void> duplicateFolder(String folderId) async {
    await dio.post('/training-folders/$folderId/duplicate');
  }

  Future<void> archiveFolder(String folderId) async {
    await dio.post('/training-folders/$folderId/archive');
  }

  Future<void> restoreFolder(String folderId) async {
    await dio.patch('/training-folders/$folderId/restore');
  }

  Future<List<dynamic>> getExercises({
    required String planId,
    required String folderId,
  }) async {
    final res = await dio.get(
      '/training-plans/$planId/exercises',
      queryParameters: {'folderId': folderId},
    );
    return _extractList(res.data);
  }
}