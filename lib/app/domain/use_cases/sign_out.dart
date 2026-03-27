import 'package:future_pos/app/domain/domain.dart';
import 'package:future_pos/core/core.dart';

class SignOut extends UseCaseWithoutParams<void> {
  const SignOut({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  ResultFuture<void> call() => _authRepository.signOut();
}
