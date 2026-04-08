import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class DioErrorMapper {
  static ApiException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      default:
        final code = e.response?.statusCode;

        if (code == 401) return const UnauthorizedException();
        if (code != null && code >= 500) return const ServerException();

        return ApiException(
          e.message ?? 'Unbekannter Fehler aufgetreten',
          code,
        );
    }
  }
}