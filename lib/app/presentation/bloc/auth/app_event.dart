part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

// abstract class AppEvent extends Equatable{
//   const AppEvent();
//
//   @override
//   List<Object?> get props => [];
// }

class AuthStarted extends AppEvent {}

class AuthLoggedIn extends AppEvent {
  final String email;
  final String password;

  const AuthLoggedIn(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthLoggedOut extends AppEvent {}

class AuthPhoneNumberVerified extends AppEvent {
  final String phoneNumber;
  final Duration timeout;

  const AuthPhoneNumberVerified(this.phoneNumber, this.timeout);

  @override
  List<Object?> get props => [phoneNumber, timeout];
}

class AuthPhoneOTPVerified extends AppEvent {
  final String verificationId;
  final String otp;

  const AuthPhoneOTPVerified(this.verificationId, this.otp);

  @override
  List<Object?> get props => [verificationId, otp];
}

class AuthGoogleSignInRequested extends AppEvent {}

class AuthRegister extends AppEvent {
  final String email;
  final String password;
  final String phoneNumber;
  final String name;

  const AuthRegister(this.email, this.password, this.phoneNumber, this.name);

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}

// New state for email verification
class AuthEmailVerification extends AppEvent {
  final String email;

  const AuthEmailVerification(this.email);

  @override
  List<Object?> get props => [email];
}

class NavigateToRegistrationScreen extends AppEvent {}

class NavigateToLoginScreen extends AppEvent {}

class NavigateToHomeScreen extends AppEvent {}

class NavigateToOrderListScreen extends AppEvent {}

class NavigateToAddPrintersScreen extends AppEvent {}

class NavigateToPrintersScreen extends AppEvent {}

class NavigateToCreateProductScreen extends AppEvent {
  final ProductModel? product;
  final String? barcode;
  final bool? isEdit;
  final StoreModel? store;

  const NavigateToCreateProductScreen([
    this.product,
    this.barcode,
    this.isEdit,
    this.store,
  ]);
}

class NavigateToBarcodeScannerScreen extends AppEvent {}

class NavigateToProductListScreen extends AppEvent {}

class NavigateToReportByCustomersScreen extends AppEvent {}

class NavigateToReportByDatesScreen extends AppEvent {}

class NavigateToReportByEmployeeScreen extends AppEvent {}

class NavigateToSaleReportScreen extends AppEvent {}

class NavigateToReportsScreen extends AppEvent {}

class NavigateToSaleScreen extends AppEvent {}

class NavigateToSettingsScreen extends AppEvent {}

class NavigateToStockScreen extends AppEvent {}

class NavigateToStockAdjustmentScreen extends AppEvent {}

class NavigateToAddEditStoreScreen extends AppEvent {
  final StoreModel? storeModel;

  const NavigateToAddEditStoreScreen([this.storeModel]);
}

class NavigateToStoreListScreen extends AppEvent {}
