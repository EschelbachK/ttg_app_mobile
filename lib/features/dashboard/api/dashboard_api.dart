import 'package:dio/dio.dart';

class DashboardApi {
  final Dio dio;

  DashboardApi(this.dio);

  Future<List<dynamic>> getFolders(String trainingPlanId) async {
    try {
      final response = await dio.get('/training-plans/$trainingPlanId/folders');
      final data = response.data;

      if (data is List) return data;
      if (data is Map && data['content'] is List) {
        return List<dynamic>.from(data['content']);
      }

      return [];
    } catch (_) {
      return [];
    }
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

  Future<Map<String, dynamic>> createTrainingPlan(String name) async {
    final response = await dio.post(
      '/training-plans',
      data: {'title': name},
    );

    final data = response.data;

    if (data is Map<String, dynamic>) return data;

    return {};
  }

  Future<void> deleteFolder(String id) async {
    await dio.delete('/training-folders/$id');
  }
}