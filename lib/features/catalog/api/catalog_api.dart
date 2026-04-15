import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogApi {
  static const _base = "http://10.0.2.2:8080/api/exercise-catalog";

  Future<List<dynamic>> _get(String path) async {
    final res = await http.get(
      Uri.parse("$_base$path"),
      headers: {"Content-Type": "application/json"},
    );

    if (res.statusCode != 200) {
      throw Exception("Request failed: ${res.statusCode}");
    }

    final list = jsonDecode(res.body) as List;

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