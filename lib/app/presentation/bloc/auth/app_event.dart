part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AppEvent {}

class AuthLoggedIn extends AppEvent {
  final String email;
  final String password;

  const AuthLoggedIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLoggedOut extends AppEvent {}

class FetchUserByIDs extends AppEvent {
  final String userID;

  FetchUserByIDs({required this.userID});

  @override
  List<Object?> get props => [userID];
}

class AuthPhoneNumberVerified extends AppEvent {
  final String phoneNumber;
  final Duration timeout;

  const AuthPhoneNumberVerified({required this.phoneNumber, required this.timeout});

  @override
  List<Object?> get props => [phoneNumber, timeout];
}

class AuthPhoneOTPVerified extends AppEvent {
  final String verificationId;
  final String otp;

  const AuthPhoneOTPVerified({required this.verificationId, required this.otp});

  @override
  List<Object?> get props => [verificationId, otp];
}

class AuthGoogleSignInRequested extends AppEvent {}

class AuthRegister extends AppEvent {
  final String email;
  final String password;
  final String phoneNumber;
  final String name;

  const AuthRegister(
      {required this.email, required this.password, required this.phoneNumber, required this.name});

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}

// New state for email verification
class AuthEmailVerification extends AppEvent {
  final String email;

  const AuthEmailVerification({required this.email});

  @override
  List<Object?> get props => [email];
}

class NavigateToRegistrationScreen extends AppEvent {}

class NavigateToLoginScreen extends AppEvent {}

class NavigateToHomeScreen extends AppEvent {
  final String? storeID;

  const NavigateToHomeScreen({this.storeID});

  @override
  // TODO: implement props
  List<Object?> get props => [storeID];
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

class NavigateToCreateEditProductScreen extends AppEvent {
  final String? productID;
  final String? barcode;
  final bool? isEdit;
  final String? storeID;

  const NavigateToCreateEditProductScreen([
    this.productID,
    this.barcode,
    this.isEdit = false,
    this.storeID,
  ]);

  @override
  // TODO: implement props
  List<Object?> get props => [productID, barcode, storeID, isEdit];
}

class NavigateToBarcodeScannerScreen extends AppEvent {}

class NavigateToProductListScreen extends AppEvent {
  final String? storeID;

  const NavigateToProductListScreen({required this.storeID});

  @override
  // TODO: implement props
  List<Object?> get props => [storeID];
}

class NavigateToReportByCustomersScreen extends AppEvent {}

class NavigateToReportByDatesScreen extends AppEvent {}

class NavigateToReportByEmployeeScreen extends AppEvent {}

class NavigateToSaleReportScreen extends AppEvent {}

class NavigateToReportsScreen extends AppEvent {}

class NavigateToSaleScreen extends AppEvent {
  final String? storeID;

  const NavigateToSaleScreen({required this.storeID});

  @override
  // TODO: implement props
  List<Object?> get props => [storeID];
}

class NavigateToSettingsScreen extends AppEvent {}

class NavigateToStocksScreen extends AppEvent {
  final String storeID;
  const NavigateToStocksScreen({required this.storeID});
  @override
  // TODO: implement props
  List<Object?> get props => [storeID];
}
class NavigateToCreateEditStockScreen extends AppEvent {
  final String? stockID;
  final String? barcode;
  final bool? isEdit;
  final String? storeID;

  const NavigateToCreateEditStockScreen([
    this.stockID,
    this.barcode,
    this.isEdit = false,
    this.storeID,
  ]);

  @override
  // TODO: implement props
  List<Object?> get props => [stockID, barcode, storeID, isEdit];
}


class NavigateToAddEditStoreScreen extends AppEvent {
  final String? storeID;
  final bool? isEdit;

  const NavigateToAddEditStoreScreen({
    required this.storeID,
    this.isEdit = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [storeID, isEdit];
}

class NavigateToStoreListScreen extends AppEvent {}
