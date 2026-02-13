import 'package:uv_pos/app/domain/domain.dart';
import 'package:uv_pos/core/core.dart';

class SignUp extends UseCaseWithParams<UserEntity, SignUpParameters> {
  const SignUp({required AuthRepository authRepository}) : _authRepository = authRepository;
  final AuthRepository _authRepository;

  @override
  ResultFuture<UserEntity> call(SignUpParameters params) =>
      _authRepository.signUpWithEmail(email: params.email!, password: params.password!);
}
