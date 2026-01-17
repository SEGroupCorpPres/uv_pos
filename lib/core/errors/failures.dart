import 'package:uv_pos/core/core.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

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

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(String message) : super(message, '403');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message, '404');
}
