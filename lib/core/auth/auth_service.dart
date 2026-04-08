import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/models/auth_response.dart';
import '../network/dio_provider.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {
        'refreshToken': refreshToken,
      },
    );
    return AuthResponse.fromJson(response.data['data']);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});