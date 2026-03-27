import 'package:future_pos/core/core.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code = '401']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(String message) : super(message, '403');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message, '404');
}
