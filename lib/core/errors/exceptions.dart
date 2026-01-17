import 'package:uv_pos/core/core.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final dynamic code;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.code, this.stackTrace]);
}

abstract class AppExceptionWithStacktrace extends Equatable implements Exception {
  final String message;
  final Object? exception;
  final StackTrace? stackTrace;

  const AppExceptionWithStacktrace(this.message, [this.exception, this.stackTrace]);
}

class BadRequestException extends AppException {
  const BadRequestException(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ConflictException extends AppException {
  const ConflictException(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class InternalServerErrorException extends AppException {
  const InternalServerErrorException(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class CacheException extends AppException {
  const CacheException(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ValidationException extends AppException {
  const ValidationException(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message, 401);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ForbiddenException extends AppException {
  const ForbiddenException(String message) : super(message, 403);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message, 404);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

// Convert AppException to a mixin
mixin AppExceptionMixin {
  String get message;

  Object? get exception;

  StackTrace? get stackTrace;
}
