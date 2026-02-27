import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../core/network/dio_provider.dart';
import '../models/auth_response.dart';
import 'token_storage.dart';

class ApiService {
  final Ref ref;

  ApiService(this.ref);

  Future<AuthResponse> login(
      String email,
      String password,
      ) async {

    final dio = ref.read(dioProvider);
    final tokenStorage = ref.read(tokenStorageProvider);

    final response = await dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    final authResponse =
    AuthResponse.fromJson(response.data);

    await tokenStorage.saveTokens(
      authResponse.accessToken,
      authResponse.refreshToken,
    );

    return authResponse;
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
});