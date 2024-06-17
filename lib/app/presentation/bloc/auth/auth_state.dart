// auth_flow.dart
part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  authenticated,
  loading,
  otpVerification,
  emailVerification,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? email;
  final String? phone;
  final String? errorMessage;
  final String? otp;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.email,
    this.phone,
    this.otp,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? email,
    String? phone,
    String? otp,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        email,
        phone,
        otp,
        errorMessage,
      ];
}
