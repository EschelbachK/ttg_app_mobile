import 'package:dio/dio.dart';

class CatalogApi {
  final Dio dio;

  CatalogApi(this.dio);

  Future<List<dynamic>> _get(String path) async {
    final res = await dio.get("/exercise-catalog$path");

    final list = List<dynamic>.from(res.data);

    list.sort((a, b) {
      final aName = (a["name"] ?? "").toString().toLowerCase();
      final bName = (b["name"] ?? "").toString().toLowerCase();
      return aName.compareTo(bName);
    });

    return list;
  }

  Future<List<dynamic>> fetchExercises() => _get("/all");

  Future<List<dynamic>> searchExercises(String q) =>
      _get("/search?q=$q");
}