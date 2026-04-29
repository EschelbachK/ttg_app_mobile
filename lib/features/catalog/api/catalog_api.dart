import 'package:dio/dio.dart';

class CatalogApi {
  final Dio dio;
  CatalogApi(this.dio);

  Future<List<Map<String, dynamic>>> _get(String path, {Map<String, dynamic>? queryParameters}) async {
    final res = await dio.get("/exercise-catalog$path", queryParameters: queryParameters);
    final data = res.data as List<dynamic>? ?? [];
    final list = data.map((e) => Map<String, dynamic>.from(e)).toList();
    list.sort((a, b) => (a["name"] ?? "").toString().toLowerCase().compareTo((b["name"] ?? "").toString().toLowerCase()));
    return list;
  }

  Future<List<Map<String, dynamic>>> fetchExercises({Map<String, dynamic>? filter, int page = 1, int size = 20}) =>
      _get("/all", queryParameters: {'page': page, 'size': size, ...?filter});

  Future<List<Map<String, dynamic>>> searchExercises(String query) =>
      _get("/search", queryParameters: {'q': query});

  Future<Map<String, dynamic>> fetchExerciseDetail(String id) async {
    final res = await dio.get("/exercise-catalog/$id");
    return Map<String, dynamic>.from(res.data as Map<String, dynamic>);
  }
}