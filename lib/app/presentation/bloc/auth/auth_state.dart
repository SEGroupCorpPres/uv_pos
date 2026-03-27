// lib/app/presentation/blocs/auth/auth_state.dart

part of 'auth_bloc.dart';

/// Base class for all auth states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// OTP sent state (for phone authentication)
class AuthOtpSent extends AuthState {
  const AuthOtpSent({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}

/// Email verification sent state
class AuthEmailVerificationSent extends AuthState {
  const AuthEmailVerificationSent();
}

/// Password reset email sent state
class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Profile updated state
class AuthProfileUpdated extends AuthState {
  const AuthProfileUpdated({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Password changed state
class AuthPasswordChanged extends AuthState {
  const AuthPasswordChanged();
}

/// Email verified state
class AuthEmailVerified extends AuthState {
  const AuthEmailVerified();
}

/// Error state
class AuthError extends AuthState {
  const AuthError({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Account deleted state
class AuthAccountDeleted extends AuthState {
  const AuthAccountDeleted();
}