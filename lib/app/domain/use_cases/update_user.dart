import 'package:uv_pos/app/domain/domain.dart';
import 'package:uv_pos/core/core.dart';

class UpdateUser extends UseCaseWithParams<UserEntity, UpdateUserParameters> {
  UpdateUser({required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  ResultFuture<UserEntity> call(UpdateUserParameters params) =>
      _authRepository.updateProfile(displayName: params.displayName, photoUrl: params.photoUrl);
}
