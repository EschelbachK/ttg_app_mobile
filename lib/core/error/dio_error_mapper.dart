import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class DioErrorMapper {
  static ApiException map(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkException();
    }

    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return UnauthorizedException();
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException();
    }

    return ApiException(
      message: error.message ?? 'Unexpected error occurred',
      statusCode: statusCode,
    );
  }
}