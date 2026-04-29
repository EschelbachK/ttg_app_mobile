class AppError {
  final String message;
  final int? statusCode;

  const AppError(this.message, [this.statusCode]);
}