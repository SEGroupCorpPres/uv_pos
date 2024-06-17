part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLoggedIn(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthLoggedOut extends AuthEvent {}

class AuthPhoneNumberVerified extends AuthEvent {
  final String phoneNumber;
  final Duration timeout;

  const AuthPhoneNumberVerified(this.phoneNumber, this.timeout);

  @override
  List<Object?> get props => [phoneNumber, timeout];
}

class AuthPhoneOTPVerified extends AuthEvent {
  final String verificationId;
  final String otp;

  const AuthPhoneOTPVerified(this.verificationId, this.otp);

  @override
  List<Object?> get props => [verificationId, otp];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String phoneNumber;
  final String name;

  const AuthRegister(this.email, this.password, this.phoneNumber, this.name);

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}
// New state for email verification
class AuthEmailVerification extends AuthEvent {
  final String email;

  const AuthEmailVerification(this.email);

  @override
  List<Object?> get props => [email];
}