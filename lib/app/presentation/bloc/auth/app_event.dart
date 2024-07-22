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

class NavigateToHomeScreen extends AppEvent {
  final StoreModel? store;

  const NavigateToHomeScreen([this.store]);

  @override
  // TODO: implement props
  List<Object?> get props => [store];
}

class NavigateToOrderListScreen extends AppEvent {
  final StoreModel? store;

  const NavigateToOrderListScreen(this.store);

  @override
  // TODO: implement props
  List<Object?> get props => [store];
}

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
    this.isEdit = false,
    this.store,
  ]);

  @override
  // TODO: implement props
  List<Object?> get props => [product, barcode, store, isEdit];
}

class NavigateToBarcodeScannerScreen extends AppEvent {}

class NavigateToProductListScreen extends AppEvent {
  final StoreModel? store;

  const NavigateToProductListScreen(this.store);

  @override
  // TODO: implement props
  List<Object?> get props => [store];
}

class NavigateToReportByCustomersScreen extends AppEvent {}

class NavigateToReportByDatesScreen extends AppEvent {}

class NavigateToReportByEmployeeScreen extends AppEvent {}

class NavigateToSaleReportScreen extends AppEvent {}

class NavigateToReportsScreen extends AppEvent {}

class NavigateToSaleScreen extends AppEvent {
  final StoreModel? store;

  const NavigateToSaleScreen(this.store);

  @override
  // TODO: implement props
  List<Object?> get props => [store];
}

class NavigateToSettingsScreen extends AppEvent {}

class NavigateToStockScreen extends AppEvent {}


class NavigateToAddEditStoreScreen extends AppEvent {
  final StoreModel? store;
  final bool? isEdit;

  const NavigateToAddEditStoreScreen([
    this.store,
    this.isEdit = false,
  ]);

  @override
  // TODO: implement props
  List<Object?> get props => [store, isEdit];
}

class NavigateToStoreListScreen extends AppEvent {}
