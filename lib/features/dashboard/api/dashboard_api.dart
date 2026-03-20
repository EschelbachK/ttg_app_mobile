import 'package:dio/dio.dart';

class DashboardApi {
  final Dio dio;

  DashboardApi(this.dio);

  Future<List<dynamic>> getFolders(String trainingPlanId) async {
    final response = await dio.get(
      '/training-folders',
      queryParameters: {
        'trainingPlanId': trainingPlanId,
      },
    );

    return List<dynamic>.from(response.data);
  }

  Future<void> createFolder({
    required String trainingPlanId,
    required String name,
    required int order,
  }) async {
    await dio.post(
      '/training-folders',
      data: {
        'trainingPlanId': trainingPlanId,
        'name': name,
        'order': order,
      },
    );
  }

  Future<void> deleteFolder(String id) async {
    await dio.delete('/training-folders/$id');
  }
}