import 'dart:convert';
import '../models/auth_response.dart';
import '../core/network/api_client.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient();

  // 🔐 LOGIN
  Future<AuthResponse> login(String email, String password) async {
    final response = await _apiClient.post(
      "/api/auth/login",
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data["data"]);
    } else {
      throw Exception("Login failed: ${response.statusCode}");
    }
  }
}