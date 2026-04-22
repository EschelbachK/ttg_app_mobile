import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/token_storage.dart';
import '../auth/auth_provider.dart';
import '../error/api_exceptions.dart';
import '../error/dio_error_mapper.dart';
import 'dio_provider.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  bool _isAuthPath(String path) =>
      path.contains('/auth/login') ||
          path.contains('/auth/register') ||
          path.contains('/auth/refresh');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isAuthPath(options.path)) return handler.next(options);

    final token = await ref.read(tokenStorageProvider).getAccessToken();

    if (token?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isAuthPath(err.requestOptions.path)) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      try {
        await ref.read(authProvider.notifier).refreshToken();

        final token = await ref.read(tokenStorageProvider).getAccessToken();
        if (token == null || token.isEmpty) throw UnauthorizedException();

        final request = err.requestOptions..headers['Authorization'] = 'Bearer $token';

        final response = await ref.read(dioProvider).fetch(request);
        return handler.resolve(response);
      } catch (_) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const UnauthorizedException(),
          ),
        );
      }
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: DioErrorMapper.map(err),
      ),
    );
  }
}