import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/models/auth_response.dart';
import '../network/dio_provider.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<AuthResponse> login(String email, String password) async {
    final res = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(res.data);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final res = await dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return AuthResponse.fromJson(res.data);
  }

  Future<void> register(String email, String username, String password) async {
    await dio.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
    });
  }

  Future<void> forgotPassword(String email) async {
    await dio.post('/auth/password/forgot', queryParameters: {
      'email': email,
    });
  }

  Future<void> resetPassword(String token, String password) async {
    await dio.post('/auth/password/reset', queryParameters: {
      'token': token,
      'password': password,
    });
  }
}

final authServiceProvider =
Provider<AuthService>((ref) => AuthService(ref.read(dioProvider)));