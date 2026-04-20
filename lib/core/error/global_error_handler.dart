import 'package:dio/dio.dart';
import 'app_error.dart';
import 'dio_error_mapper.dart';

class GlobalErrorHandler {
  static AppError handle(Object error) {
    if (error is DioException) {
      if (error.error == 'OFFLINE_MODE') {
        return const AppError('Offline-Modus aktiv');
      }

      final mapped = DioErrorMapper.map(error);
      return AppError(mapped.message, mapped.statusCode);
    }

    if (error is Exception) {
      return AppError(error.toString());
    }

    return const AppError('Unbekannter Fehler');
  }
}