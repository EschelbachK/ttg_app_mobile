class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException()
      : super(message: 'No internet connection');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException()
      : super(message: 'Session expired. Please login again.', statusCode: 401);
}

class ServerException extends ApiException {
  ServerException()
      : super(message: 'Server error. Please try again later.');
}