import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/models/auth_response.dart';
import '../network/api_client.dart';

class AuthService {
  final ApiClient api;

  AuthService(this.api);

  Future<AuthResponse> login(String email, String password) async {
    final res = await api.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(res.data);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final res = await api.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return AuthResponse.fromJson(res.data);
  }

  Future<void> register(String email, String username, String password) async {
    await api.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
    });
  }

  Future<void> forgotPassword(String email) async {
    await api.post('/auth/password/forgot', data: {
      'email': email,
    });
  }

  Future<void> resetPassword(String token, String password) async {
    await api.post('/auth/password/reset', data: {
      'token': token,
      'password': password,
    });
  }
}

final authServiceProvider =
Provider<AuthService>((ref) => AuthService(ref.read(apiClientProvider)));