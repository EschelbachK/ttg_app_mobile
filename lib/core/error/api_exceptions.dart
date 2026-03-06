class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'No internet connection'])
      : super(message: message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Session expired'])
      : super(message: message, statusCode: 401);
}

class ServerException extends ApiException {
  const ServerException([String message = 'Server error'])
      : super(message: message);
}