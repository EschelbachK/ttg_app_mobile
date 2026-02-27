import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/token_storage.dart';
import '../auth/auth_provider.dart';
import '../error/app_exceptions.dart';

class ApiClient {
  final Ref ref;
  final String baseUrl = "http://10.0.2.2:8080";
  final TokenStorage _tokenStorage = TokenStorage();

  ApiClient(this.ref);

  Future<http.Response> get(String endpoint) async {
    return _sendRequest("GET", endpoint);
  }

  Future<http.Response> post(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    return _sendRequest("POST", endpoint, body: body);
  }

  Future<http.Response> _sendRequest(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    try {
      String? accessToken = await _tokenStorage.getAccessToken();

      final headers = {
        "Content-Type": "application/json",
        if (accessToken != null)
          "Authorization": "Bearer $accessToken",
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

      // 🔥 Handle 401 → try refresh
      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry original request
          return _sendRequest(method, endpoint, body: body);
        } else {
          // Refresh failed → logout globally
          await _tokenStorage.clearTokens();
          ref.read(authProvider.notifier).logout();
          throw const UnauthorizedException("Session expired.");
        }
      }

      // 🔥 Structured Error Handling
      if (response.statusCode >= 500) {
        throw const ServerException("Server error occurred.");
      }

      if (response.statusCode >= 400) {
        throw const NetworkException("Request failed.");
      }

      return response;
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw const NetworkException("Unexpected network error.");
    }
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
      final json = jsonDecode(response.body);

      final newAccessToken = json["data"]["accessToken"];
      final newRefreshToken = json["data"]["refreshToken"];

      await _tokenStorage.saveTokens(
        newAccessToken,
        newRefreshToken,
      );

      return true;
    }

    return false;
  }
}