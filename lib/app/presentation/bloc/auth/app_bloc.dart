import '../bloc.dart';

// Events
part 'app_event.dart';
// States
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;

  AppBloc({required AuthenticationRepository userRepository})
      : _authenticationRepository = userRepository,
        super(const AppState(status: AppStatus.initial)) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthPhoneNumberVerified>(_onAuthPhoneNumberVerified);
    on<AuthPhoneOTPVerified>(_onAuthPhoneOTPVerified);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthRegister>(_onAuthRegister);
    on<NavigateToRegistrationScreen>(_onNavigateRegisterScreen);
    on<NavigateToLoginScreen>(_onNavigateLoginScreen);
    on<NavigateToHomeScreen>(_onNavigateHomeScreen);
    on<NavigateToOrderListScreen>(_onNavigateOrderListScreen);
    on<NavigateToAddPrintersScreen>(_onNavigateAddPrintersScreen);
    on<NavigateToPrintersScreen>(_onNavigatePrintersScreen);
    on<NavigateToCreateEditProductScreen>(_onNavigateCreateEditProductScreen);
    on<NavigateToBarcodeScannerScreen>(_onNavigateBarcodeScannerScreen);
    on<NavigateToProductListScreen>(_onNavigateProductListScreen);
    on<NavigateToReportByCustomersScreen>(_onNavigateReportByCustomersScreen);
    on<NavigateToReportByDatesScreen>(_onNavigateReportByDatesScreen);
    on<NavigateToReportByEmployeeScreen>(_onNavigateReportByEmployeeScreen);
    on<NavigateToSaleReportScreen>(_onNavigateSaleReportScreen);
    on<NavigateToReportsScreen>(_onNavigateReportsScreen);
    on<NavigateToSaleScreen>(_onNavigateSaleScreen);
    on<NavigateToSettingsScreen>(_onNavigateSettingsScreen);
    on<NavigateToStocksScreen>(_onNavigateStocksScreen);
    on<NavigateToCreateEditStockScreen>(_onNavigateCreateEditStockScreen);

    on<NavigateToAddEditStoreScreen>(_onNavigateAddEditStoreScreen);
    on<NavigateToStoreListScreen>(_onNavigateStoreListScreen);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AppState> emit) async {
    final user = await _authenticationRepository.getUser();
    if (user != null) {
      emit(state.copyWith(
        status: AppStatus.authenticated,
        userID: user.uid,
      ));
    } else {
      emit(state.copyWith(status: AppStatus.unauthenticated));
    }
  }

  void _onAuthLoggedIn(AuthLoggedIn event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final user = await _authenticationRepository.signInWithEmail(
        event.email,
        event.password,
      );
      emit(
        state.copyWith(
          status: AppStatus.authenticated,
          userID: user.uid,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onAuthLoggedOut(AuthLoggedOut event, Emitter<AppState> emit) async {
    await _authenticationRepository.signOut();
    emit(state.copyWith(status: AppStatus.unauthenticated));
  }

  void _onAuthPhoneNumberVerified(AuthPhoneNumberVerified event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));

    await _authenticationRepository.verifyPhoneNumber(
      event.phoneNumber,
      event.timeout,
      codeSent: (verificationId) {
        emit(state.copyWith(status: AppStatus.otpVerification, otp: verificationId));
      },
      verificationCompleted: (credential) async {
        final user = await _authenticationRepository.verifyOTP(
          credential.verificationId!,
          credential.smsCode!,
        );
        emit(state.copyWith(status: AppStatus.authenticated, userID: user.uid));
      },
      verificationFailed: (e) {
        emit(
          state.copyWith(
            status: AppStatus.unauthenticated,
            errorMessage: e.toString(),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // Handle code auto-retrieval timeout if needed
      },
    );
  }

  void _onAuthPhoneOTPVerified(AuthPhoneOTPVerified event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      await _authenticationRepository.verifyOTP(event.verificationId, event.otp);
      emit(state.copyWith(status: AppStatus.authenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final user = await _authenticationRepository.signInWithGoogle();
      emit(state.copyWith(status: AppStatus.authenticated, userID: user.uid));
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onAuthRegister(AuthRegister event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    try {
      await _authenticationRepository.createUser(
        event.email,
        event.password,
        event.phoneNumber,
        event.name,
      );
      emit(state.copyWith(status: AppStatus.emailVerification, email: event.email));
    } catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onNavigateRegisterScreen(NavigateToRegistrationScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.registration,
      ),
    );
  }

  void _onNavigateLoginScreen(NavigateToLoginScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.unauthenticated,
      ),
    );
  }

  void _onNavigateHomeScreen(NavigateToHomeScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.homeScreen,
        storeID: event.storeID,
      ),
    );
  }

  void _onNavigateOrderListScreen(NavigateToOrderListScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.orderListScreen,
        storeID: event.store!.id,
      ),
    );
  }

  void _onNavigateAddPrintersScreen(
      NavigateToAddPrintersScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.addPrintersScreen,
      ),
    );
  }

  void _onNavigatePrintersScreen(NavigateToPrintersScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.printersScreen,
      ),
    );
  }

  void _onNavigateCreateEditProductScreen(
      NavigateToCreateEditProductScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.createEditProductScreen,
        productID: event.productID,
        barcode: event.barcode,
        isEdit: event.isEdit,
        storeID: event.storeID,
      ),
    );
  }

  void _onNavigateBarcodeScannerScreen(
      NavigateToBarcodeScannerScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.barcodeScannerScreen,
      ),
    );
  }

  void _onNavigateProductListScreen(
      NavigateToProductListScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.productListScreen,
        storeID: event.storeID,
      ),
    );
  }

  void _onNavigateReportByCustomersScreen(
      NavigateToReportByCustomersScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.reportByCustomersScreen,
      ),
    );
  }

  void _onNavigateReportByDatesScreen(
      NavigateToReportByDatesScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.reportByDatesScreen,
      ),
    );
  }

  void _onNavigateReportByEmployeeScreen(
      NavigateToReportByEmployeeScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.reportByEmployeeScreen,
      ),
    );
  }

  void _onNavigateSaleReportScreen(NavigateToSaleReportScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.saleReportScreen,
      ),
    );
  }

  void _onNavigateReportsScreen(NavigateToReportsScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.reportsScreen,
      ),
    );
  }

  void _onNavigateSaleScreen(NavigateToSaleScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.saleScreen,
        storeID: event.storeID,
      ),
    );
  }

  void _onNavigateSettingsScreen(NavigateToSettingsScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.settingsScreen,
      ),
    );
  }

  void _onNavigateStocksScreen(NavigateToStocksScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.stocksScreen,
      ),
    );
  }
  void _onNavigateCreateEditStockScreen(
      NavigateToCreateEditStockScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.addEditStockScreen,
        stockID: event.stockID,

        barcode: event.barcode,
        isEdit: event.isEdit,
        storeID: event.storeID,
      ),
    );
  }

  void _onNavigateAddEditStoreScreen(
      NavigateToAddEditStoreScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.addEditStoreScreen,
        storeID: event.storeID,
        isEdit: event.isEdit,
      ),
    );
  }

  void _onNavigateStoreListScreen(NavigateToStoreListScreen event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        status: AppStatus.storeListScreen,
      ),
    );
  }
}
