import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/domain/repositories/auth_repository.dart';
import 'package:uv_pos/features/data/remote/models/user_model.dart';

// Events
part 'auth_event.dart';
// States
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository;

  AuthBloc({required AuthenticationRepository userRepository})
      : _authenticationRepository = userRepository,
        super(const AuthState(status: AuthStatus.initial)) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthPhoneNumberVerified>(_onAuthPhoneNumberVerified);
    on<AuthPhoneOTPVerified>(_onAuthPhoneOTPVerified);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthRegister>(_onAuthRegister);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await _authenticationRepository.getUser();
    if (user != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  void _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authenticationRepository.signInWithEmail(
        event.email,
        event.password,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await _authenticationRepository.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  void _onAuthPhoneNumberVerified(AuthPhoneNumberVerified event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    await _authenticationRepository.verifyPhoneNumber(
      event.phoneNumber,
      event.timeout,
      codeSent: (verificationId) {
        emit(state.copyWith(status: AuthStatus.otpVerification, otp: verificationId));
      },
      verificationCompleted: (credential) async {
        final user = await _authenticationRepository.verifyOTP(
          credential.verificationId!,
          credential.smsCode!,
        );
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      },
      verificationFailed: (e) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: e.toString(),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Handle code auto-retrieval timeout if needed
      },
    );
  }

  void _onAuthPhoneOTPVerified(AuthPhoneOTPVerified event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authenticationRepository.verifyOTP(event.verificationId, event.otp);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authenticationRepository.signInWithGoogle();
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onAuthRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authenticationRepository.createUser(
        event.email,
        event.password,
        event.phoneNumber,
        event.name,
      );
      emit(state.copyWith(status: AuthStatus.emailVerification, email: event.email));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
