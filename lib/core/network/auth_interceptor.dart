import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/token_storage.dart';
import '../auth/auth_provider.dart';
import '../error/api_exceptions.dart';
import '../error/dio_error_mapper.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] =
      'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode == 401) {
      try {
        final authNotifier =
        ref.read(authProvider.notifier);

        await authNotifier.refreshToken();

        final tokenStorage =
        ref.read(tokenStorageProvider);
        final newToken =
        await tokenStorage.getAccessToken();

        final requestOptions = err.requestOptions;

        requestOptions.headers['Authorization'] =
        'Bearer $newToken';

        final cloneReq =
        await Dio().fetch(requestOptions);

        return handler.resolve(cloneReq);
      } catch (_) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(),
          ),
        );
      }
    }

    final mappedError = DioErrorMapper.map(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mappedError,
      ),
    );
  }}