import 'package:dio/dio.dart';
import 'app_error.dart';

class GlobalErrorHandler {
  static AppError handle(Object error) {
    if (error is DioException) {
      final e = error.error;

      if (e is AppError) return e;

      return AppError(
        message: error.message ?? 'Unexpected error',
        statusCode: error.response?.statusCode,
      );
    }

    return const AppError(message: 'Unexpected error');
  }
}