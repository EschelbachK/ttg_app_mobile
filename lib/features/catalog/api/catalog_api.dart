import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogApi {

  static const String baseUrl =
      "http://10.0.2.2:8080/api/exercise-catalog/all";

  Future<List<dynamic>> fetchExercises() async {

    print("Fetching exercises...");

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      print("Loaded exercises: ${data.length}");

      return data;

    } else {

      throw Exception("Failed to load exercise catalog");
    }
  }

  Future<List<dynamic>> searchExercises(String query) async {

    print("Searching exercises: $query");

    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/exercise-catalog/search?q=$query"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("SEARCH STATUS: ${response.statusCode}");
    print("SEARCH BODY: ${response.body}");

    if (response.statusCode == 200) {

      final List data = jsonDecode(response.body);

      print("Search results: ${data.length}");

      return data;

    } else {

      throw Exception("Search failed");
    }
  }
}