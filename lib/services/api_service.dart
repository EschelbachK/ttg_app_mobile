import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client_provider.dart';
import '../models/auth_response.dart';

class ApiService {
  final Ref ref;

  ApiService(this.ref);

  Future<AuthResponse> login(String email, String password) async {
    final apiClient = ref.read(apiClientProvider);

    final response = await apiClient.post(
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
      throw Exception("Login failed");
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
});