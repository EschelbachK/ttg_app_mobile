class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'Keine Internetverbindung'])
      : super(message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Sitzung abgelaufen'])
      : super(message, 401);
}

class ServerException extends ApiException {
  const ServerException([String message = 'Serverfehler'])
      : super(message);
}