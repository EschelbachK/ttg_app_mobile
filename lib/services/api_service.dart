import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client_provider.dart';
import '../models/auth_response.dart';
import 'token_storage.dart';

class ApiService {
  final Ref ref;
  final TokenStorage _tokenStorage = TokenStorage();

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

    final data = jsonDecode(response.body);
    final authResponse = AuthResponse.fromJson(data["data"]);

    // 🔥 TOKENS SPEICHERN
    await _tokenStorage.saveTokens(
      authResponse.accessToken,
      authResponse.refreshToken,
    );

    return authResponse;
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
});