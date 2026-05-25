abstract class NetworkException implements Exception {
  final String message;
  final String? code;

  NetworkException({required this.message, this.code});

  @override
  String toString() => message;
}

class ServerException extends NetworkException {
  final int statusCode;

  ServerException({
    required int this.statusCode,
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ConnectionException extends NetworkException {
  ConnectionException({required String message, String? code})
      : super(message: message, code: code);
}

class TimeoutException extends NetworkException {
  TimeoutException({required String message, String? code})
      : super(message: message, code: code);
}

class UnknownException extends NetworkException {
  UnknownException({required String message, String? code})
      : super(message: message, code: code);
}

class BadRequestException extends NetworkException {
  BadRequestException({required String message, String? code})
      : super(message: message, code: code);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException({required String message, String? code})
      : super(message: message, code: code);
}

class ForbiddenException extends NetworkException {
  ForbiddenException({required String message, String? code})
      : super(message: message, code: code);
}

class NotFoundException extends NetworkException {
  NotFoundException({required String message, String? code})
      : super(message: message, code: code);
}

