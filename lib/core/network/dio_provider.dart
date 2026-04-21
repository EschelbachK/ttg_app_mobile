import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_controller.dart';
import 'auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (ref.read(settingsProvider).offlineMode) {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.cancel,
              error: 'OFFLINE_MODE',
            ),
          );
        }
        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
});