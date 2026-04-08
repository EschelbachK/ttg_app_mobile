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

    return jsonDecode(res.body) as List;
  }

  Future<List<dynamic>> fetchExercises() => _get("/all");

  Future<List<dynamic>> searchExercises(String q) =>
      _get("/search?q=$q");
}