import 'package:uv_pos/core/core.dart';

class SignInParameters extends Equatable {
  const SignInParameters({required this.email, required this.password});

  final String? email;
  final String? password;

  @override
  List<Object?> get props => [email, password];
}
