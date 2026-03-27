// lib/app/presentation/blocs/auth/auth_event.dart

part of 'auth_bloc.dart';

/// Base class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event for email sign in
class AuthSignInWithEmailRequested extends AuthEvent {
  const AuthSignInWithEmailRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Event for email sign up
class AuthSignUpWithEmailRequested extends AuthEvent {
  const AuthSignUpWithEmailRequested({
    required this.email,
    required this.password,
    this.displayName,
  });

  final String email;
  final String password;
  final String? displayName;

  @override
  List<Object?> get props => [email, password, displayName];
}

// /// Event for Google sign in
// class AuthSignInWithGoogleRequested extends AuthEvent {
//   const AuthSignInWithGoogleRequested();
// }

/// Event for phone OTP request
class AuthSendPhoneOtpRequested extends AuthEvent {
  const AuthSendPhoneOtpRequested({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

/// Event for phone OTP verification
class AuthVerifyPhoneOtpRequested extends AuthEvent {
  const AuthVerifyPhoneOtpRequested({
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final String otp;

  @override
  List<Object?> get props => [phoneNumber, otp];
}

/// Event for sending email verification
class AuthSendEmailVerificationRequested extends AuthEvent {
  const AuthSendEmailVerificationRequested();
}

/// Event for verifying email with token
class AuthVerifyEmailRequested extends AuthEvent {
  const AuthVerifyEmailRequested({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}

/// Event for forgot password
class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Event for reset password
class AuthResetPasswordRequested extends AuthEvent {
  const AuthResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });

  final String token;
  final String newPassword;

  @override
  List<Object?> get props => [token, newPassword];
}

/// Event for updating profile
class AuthUpdateProfileRequested extends AuthEvent {
  const AuthUpdateProfileRequested({
    this.displayName,
    this.photoUrl,
  });

  final String? displayName;
  final String? photoUrl;

  @override
  List<Object?> get props => [displayName, photoUrl];
}

/// Event for changing password
class AuthChangePasswordRequested extends AuthEvent {
  const AuthChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Event for sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event for deleting account
class AuthDeleteAccountRequested extends AuthEvent {
  const AuthDeleteAccountRequested();
}

/// Event for refreshing token
class AuthRefreshTokenRequested extends AuthEvent {
  const AuthRefreshTokenRequested();
}

/// Event for auth state changes from stream
class AuthStateChanged extends AuthEvent {
  const AuthStateChanged({required this.user});

  final UserEntity? user;

  @override
  List<Object?> get props => [user];
}