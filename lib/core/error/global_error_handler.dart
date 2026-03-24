import 'package:dio/dio.dart';
import 'app_error.dart';

class GlobalErrorHandler {
  static AppError handle(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      String message = 'Unexpected error';

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data != null) {
        message = data.toString();
      } else if (error.message != null) {
        message = error.message!;
      }

      return AppError(
        message: message,
        statusCode: error.response?.statusCode,
      );
    }

    return const AppError(message: 'Unexpected error');
  }
}