import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/token_storage.dart';

class ApiClient {
  final String baseUrl = "http://10.0.2.2:8080";
  final TokenStorage _tokenStorage = TokenStorage();

  Future<http.Response> get(String endpoint) async {
    return _sendRequest("GET", endpoint);
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    return _sendRequest("POST", endpoint, body: body);
  }

  Future<http.Response> _sendRequest(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    String? accessToken = await _tokenStorage.getAccessToken();

    final headers = {
      "Content-Type": "application/json",
      if (accessToken != null) "Authorization": "Bearer $accessToken",
    };

    final uri = Uri.parse("$baseUrl$endpoint");

    http.Response response;

    if (method == "GET") {
      response = await http.get(uri, headers: headers);
    } else {
      response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
    }

    // 🔥 401 Handling
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();

      if (refreshed) {
        return _sendRequest(method, endpoint, body: body);
      }
    }

    return response;
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data["accessToken"];

      await _tokenStorage.saveAccessToken(newAccessToken);
      return true;
    }

    return false;
  }
}