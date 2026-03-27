import 'package:future_pos/app/domain/domain.dart';
import 'package:future_pos/core/use_cases/use_cases.dart';
import 'package:future_pos/core/utils/typedefs.dart';

class GetUser extends UseCaseWithoutParams<UserEntity?> {
  const GetUser({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  ResultFuture<UserEntity?> call() => _authRepository.getCurrentUser();
}
