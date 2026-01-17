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
  stocksScreen,
  addEditStockScreen,
  homeScreen,
  orderListScreen,
  addPrintersScreen,
  printersScreen,
  createEditProductScreen,
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
  final String? userID;
  final String? email;
  final String? phone;
  final String? errorMessage;
  final String? otp;
  final String? barcode;
  final String? productID;
  final String? storeID;
  final String? orderID;
  final String? stockID;
  final bool isEdit;

  const AppState({
    this.status = AppStatus.initial,
    this.userID,
    this.email,
    this.phone,
    this.otp,
    this.barcode,
    this.errorMessage,
    this.productID,
    this.storeID,
    this.stockID,
    this.orderID,
    this.isEdit = false,
  });

  AppState copyWith({
    AppStatus? status,
    String? userID,
    String? email,
    String? phone,
    String? otp,
    String? barcode,
    String? productID,
    String? storeID,
    String? stockID,
    String? orderID,
    bool? isEdit,
    String? errorMessage,
  }) {
    return AppState(
      status: status ?? this.status,
      userID: userID ?? this.userID,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      productID: productID ?? this.productID,
      storeID: storeID ?? this.storeID,
      stockID: stockID ?? this.stockID,
      orderID: orderID ?? this.orderID,
      barcode: barcode ?? this.barcode,
      isEdit: isEdit ?? this.isEdit,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userID,
        email,
        phone,
        otp,
        barcode,
        productID,
        storeID,
        stockID,
        isEdit,
        orderID,
        errorMessage,
      ];
}
