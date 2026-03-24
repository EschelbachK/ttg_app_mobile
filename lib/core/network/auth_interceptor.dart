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

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/refresh')) {
      handler.next(options);
      return;
    }

    final storage = ref.read(tokenStorageProvider);
    final token = await storage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.requestOptions.path;

    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      handler.next(err);
      return;
    }

    if (err.response?.statusCode == 401) {
      try {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.refreshToken();

        final storage = ref.read(tokenStorageProvider);
        final newToken = await storage.getAccessToken();

        if (newToken == null || newToken.isEmpty) {
          throw UnauthorizedException();
        }

        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final dio = ref.read(dioProvider);
        final response = await dio.fetch(requestOptions);

        handler.resolve(response);
        return;
      } catch (_) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(),
          ),
        );
        return;
      }
    }

    final mappedError = DioErrorMapper.map(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mappedError,
      ),
    );
  }
}