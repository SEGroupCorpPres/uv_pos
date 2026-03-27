// lib/app/presentation/blocs/auth/auth_bloc.dart
import 'package:future_pos/app/app_barrel.dart';
import 'package:future_pos/core/core.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Auth BLoC - Handles all authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    // on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSendPhoneOtpRequested>(_onSendPhoneOtpRequested);
    on<AuthVerifyPhoneOtpRequested>(_onVerifyPhoneOtpRequested);
    on<AuthSendEmailVerificationRequested>(_onSendEmailVerificationRequested);
    on<AuthVerifyEmailRequested>(_onVerifyEmailRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
    on<AuthChangePasswordRequested>(_onChangePasswordRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthDeleteAccountRequested>(_onDeleteAccountRequested);
    on<AuthRefreshTokenRequested>(_onRefreshTokenRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Listen to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user: user)),
    );
  }

  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;

  /// Check authentication status
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isAuthenticated = await _authRepository.isAuthenticated();

    if (!isAuthenticated) {
      emit(const AuthUnauthenticated());
      return;
    }

    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// Sign in with email
  Future<void> _onSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Sign up with email
  Future<void> _onSignUpWithEmailRequested(
    AuthSignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Sign in with Google
  // Future<void> _onSignInWithGoogleRequested(
  //     AuthSignInWithGoogleRequested event,
  //     Emitter<AuthState> emit,
  //     ) async {
  //   emit(const AuthLoading());
  //
  //   final result = await _authRepository.signInWithGoogle();
  //
  //   result.fold(
  //         (failure) => emit(AuthError(
  //       message: failure.message.toString(),
  //       statusCode: failure.code,
  //     )),
  //         (user) => emit(AuthAuthenticated(user: user)),
  //   );
  // }

  /// Send phone OTP
  Future<void> _onSendPhoneOtpRequested(
    AuthSendPhoneOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.sendPhoneOtp(
      phoneNumber: event.phoneNumber,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(AuthOtpSent(phoneNumber: event.phoneNumber)),
    );
  }

  /// Verify phone OTP
  Future<void> _onVerifyPhoneOtpRequested(
    AuthVerifyPhoneOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.verifyPhoneOtp(
      phoneNumber: event.phoneNumber,
      otp: event.otp,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Send email verification
  Future<void> _onSendEmailVerificationRequested(
    AuthSendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(const AuthLoading());

    final result = await _authRepository.sendEmailVerification();

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(const AuthEmailVerificationSent()),
    );

    // Return to previous state after a delay
    await Future.delayed(const Duration(seconds: 2));
    if (currentState is AuthAuthenticated) {
      emit(currentState);
    }
  }

  /// Verify email with token
  Future<void> _onVerifyEmailRequested(
    AuthVerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.verifyEmail(token: event.token);

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(const AuthEmailVerified()),
    );
  }

  /// Forgot password
  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.forgotPassword(email: event.email);

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(AuthPasswordResetEmailSent(email: event.email)),
    );
  }

  /// Reset password
  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.resetPassword(
      token: event.token,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  /// Update profile
  Future<void> _onUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.updateProfile(
      displayName: event.displayName,
      photoUrl: event.photoUrl,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (user) => emit(AuthProfileUpdated(user: user)),
    );

    // Return to authenticated state after a delay
    await Future.delayed(const Duration(seconds: 2));
    result.fold(
      (_) {},
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Change password
  Future<void> _onChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(const AuthLoading());

    final result = await _authRepository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(const AuthPasswordChanged()),
    );

    // Return to previous state after a delay
    await Future.delayed(const Duration(seconds: 2));
    if (currentState is AuthAuthenticated) {
      emit(currentState);
    }
  }

  /// Sign out
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  /// Delete account
  Future<void> _onDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authRepository.deleteAccount();

    result.fold(
      (failure) => emit(
        AuthError(
          message: failure.message,
          statusCode: failure.code,
        ),
      ),
      (_) => emit(const AuthAccountDeleted()),
    );
  }

  /// Refresh token
  Future<void> _onRefreshTokenRequested(
    AuthRefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.refreshToken();

    result.fold(
      (failure) {
        // If refresh fails, sign out
        emit(const AuthUnauthenticated());
      },
      (_) {
        // Token refreshed successfully, keep current state
      },
    );
  }

  /// Handle auth state changes from stream
  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }
}
