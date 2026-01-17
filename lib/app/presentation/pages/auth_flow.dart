// main.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/pages/stock/add_edit_stock_screen.dart';

import 'pages.dart';

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return FlowBuilder<AppState>(
          state: state,
          onGeneratePages: onGenerateAuthPages,
        );
      },
    );
  }
}

List<Page> onGenerateAuthPages(AppState state, List<Page> pages) {
  switch (state.status) {
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
    case AppStatus.registration:
      return [RegistrationScreen.page()];
    case AppStatus.authenticated:
      return [StoreListScreen.page()];
    case AppStatus.loading:
      return [LoadingScreen.page()];
    case AppStatus.emailVerification:
      return [CheckEmailScreen.page(state.email!)];
    case AppStatus.homeScreen:
      return [HomeScreen.page()];
    case AppStatus.orderListScreen:
      return [OrderListScreen.page()];
    case AppStatus.addPrintersScreen:
      return [AddPrintersScreen.page()];
    case AppStatus.printersScreen:
      return [PrintersScreen.page()];
    case AppStatus.createEditProductScreen:
      return [CreateProductScreen.page()];
    case AppStatus.barcodeScannerScreen:
      return [BarcodeScannerScreen.page()];
    case AppStatus.productListScreen:
      return [ProductListScreen.page()];
    case AppStatus.reportByCustomersScreen:
      return [ReportByCustomersScreen.page()];
    case AppStatus.reportByDatesScreen:
      return [ReportByDatesScreen.page()];
    case AppStatus.reportByEmployeeScreen:
      return [ReportByEmployeesScreen.page()];
    case AppStatus.reportsScreen:
      return [ReportsScreen.page()];
    case AppStatus.saleReportScreen:
      return [SaleReportScreen.page()];
    case AppStatus.saleScreen:
      return [SaleScreen.page()];
    case AppStatus.settingsScreen:
      return [SettingsScreen.page()];
    case AppStatus.stocksScreen:
      return [StocksScreen.page()];
    case AppStatus.addEditStockScreen:
      return [AddEditStockScreen.page()];
    case AppStatus.addEditStoreScreen:
      return [AddEditStoreScreen.page()];
    case AppStatus.storeListScreen:
      return [StoreListScreen.page()];
    default:
      return [LoadingScreen.page()];
  }
}
