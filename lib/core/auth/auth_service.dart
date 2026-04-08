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
    return AuthResponse.fromJson(res.data['data']);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final res = await dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return AuthResponse.fromJson(res.data['data']);
  }
}

final authServiceProvider = Provider<AuthService>(
      (ref) => AuthService(ref.read(dioProvider)),
);