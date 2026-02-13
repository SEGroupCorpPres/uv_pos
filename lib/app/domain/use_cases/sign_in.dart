import 'package:uv_pos/app/domain/domain.dart';
import 'package:uv_pos/core/core.dart';

class SignIn extends UseCaseWithParams<UserEntity, SignInParameters> {
  const SignIn({required AuthRepository authRepository}) : _authRepository = authRepository;
  final AuthRepository _authRepository;

  @override
  ResultFuture<UserEntity> call(SignInParameters params) =>
      _authRepository.signInWithEmail(email: params.email!, password: params.password!);
}
