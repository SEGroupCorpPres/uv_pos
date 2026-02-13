import 'package:uv_pos/core/core.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException(this.message, [this.code, this.stackTrace]);

  final String message;
  final dynamic code;
  final StackTrace? stackTrace;
}

abstract class AppExceptionWithStacktrace extends Equatable implements Exception {
  const AppExceptionWithStacktrace(this.message, [this.exception, this.stackTrace]);

  final String message;
  final Object? exception;
  final StackTrace? stackTrace;
}

class BadRequestException extends AppException {
  const BadRequestException(super.message);

  @override
  List<Object?> get props => [message];
}

class ConflictException extends AppException {
  const ConflictException(super.message);

  @override
  List<Object?> get props => [message];
}

class InternalServerErrorException extends AppException {
  const InternalServerErrorException(super.message);

  @override
  List<Object?> get props => [message];
}

class CacheException extends AppException {
  const CacheException(super.message);

  @override
  List<Object?> get props => [message];
}

class ValidationException extends AppException {
  const ValidationException(super.message);

  @override
  List<Object?> get props => [message];
}

/// Server exception
class ServerException extends AppException {
  const ServerException(super.message, [super.code]);

  @override
  List<Object?> get props => [message, code];
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException(super.message, [super.code = 401]);

  @override
  List<Object?> get props => [message, code];
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code = 503]);

  @override
  List<Object?> get props => [message, code];
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message, 401);

  @override
  List<Object?> get props => [message];
}

class ForbiddenException extends AppException {
  const ForbiddenException(String message) : super(message, 403);

  @override
  List<Object?> get props => [message];
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message, 404);

  @override
  List<Object?> get props => [message];
}

// Convert AppException to a mixin
mixin AppExceptionMixin {
  String get message;

  Object? get exception;

  StackTrace? get stackTrace;
}
