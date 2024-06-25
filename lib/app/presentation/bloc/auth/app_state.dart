// auth_flow.dart
part of 'app_bloc.dart';

enum AppStatus {
  initial,
  unauthenticated,
  authenticated,
  loading,
  registration,
  otpVerification,
  emailVerification,
  storeListScreen,
  addEditStoreScreen,
  stockAdjustmentScreen,
  stocksScreen,
  homeScreen,
  orderListScreen,
  addPrintersScreen,
  printersScreen,
  createProductScreen,
  barcodeScannerScreen,
  productListScreen,
  reportByCustomersScreen,
  reportByDatesScreen,
  reportByEmployeeScreen,
  reportsScreen,
  saleReportScreen,
  saleScreen,
  settingsScreen,
}

class AppState extends Equatable {
  final AppStatus status;
  final UserModel? user;
  final String? email;
  final String? phone;
  final String? errorMessage;
  final String? otp;
  final String? barcode;
  final ProductModel? product;
  final StoreModel? store;

  final bool isEdit;

  const AppState({
    this.status = AppStatus.initial,
    this.user,
    this.email,
    this.phone,
    this.otp,
    this.barcode,
    this.errorMessage,
    this.product,
    this.store,
    this.isEdit = false,
  });

  AppState copyWith({
    AppStatus? status,
    UserModel? user,
    String? email,
    String? phone,
    String? otp,
    String? barcode,
    ProductModel? product,
    StoreModel? store,
    bool? isEdit,
    String? errorMessage,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      product: product ?? this.product,
      store: store ?? this.store,
      barcode: barcode ?? this.barcode,
      isEdit: isEdit ?? this.isEdit,
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
        barcode,
        product,
        store,
        isEdit,
        errorMessage,
      ];
}
