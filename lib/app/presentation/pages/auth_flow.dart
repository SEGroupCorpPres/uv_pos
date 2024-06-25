// main.dart
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/app/presentation/pages/check_email_screen.dart';
import 'package:uv_pos/app/presentation/pages/loading_screen.dart';
import 'package:uv_pos/app/presentation/pages/login_screen.dart';
import 'package:uv_pos/app/presentation/pages/registration_screen.dart';
import 'package:uv_pos/features/presentation/pages/home/home_screen.dart';
import 'package:uv_pos/features/presentation/pages/order/order_list_screen.dart';
import 'package:uv_pos/features/presentation/pages/printer/add_printers_screen.dart';
import 'package:uv_pos/features/presentation/pages/printer/printers_screen.dart';
import 'package:uv_pos/features/presentation/pages/product/barcode_scanner_screen.dart';
import 'package:uv_pos/features/presentation/pages/product/create_product_screen.dart';
import 'package:uv_pos/features/presentation/pages/product/product_list_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/report_by_customers_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/report_by_dates_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/report_by_employees_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/reports_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/sale_report_screen.dart';
import 'package:uv_pos/features/presentation/pages/sale/sale_screen.dart';
import 'package:uv_pos/features/presentation/pages/setting/settings_screen.dart';
import 'package:uv_pos/features/presentation/pages/stock/stock_adjustment_screen.dart';
import 'package:uv_pos/features/presentation/pages/stock/stocks_screen.dart';
import 'package:uv_pos/features/presentation/pages/store/add_edit_store_screen.dart';
import 'package:uv_pos/features/presentation/pages/store/store_list_screen.dart';

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
    case AppStatus.createProductScreen:
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
    case AppStatus.stockAdjustmentScreen:
      return [StockAdjustmentScreen.page()];
    case AppStatus.stocksScreen:
      return [StocksScreen.page()];
    case AppStatus.addEditStoreScreen:
      return [AddEditStoreScreen.page()];
    case AppStatus.storeListScreen:
      return [StoreListScreen.page()];
    default:
      return [LoadingScreen.page()];
  }
}

// class AuthRouter extends StatelessWidget {
//   const AuthRouter({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthUnauthenticated) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => const LoginScreen(),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => const LoginScreen(),
//                   ),
//           );
//         } else if (state is AuthAuthenticated) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => const StoreListScreen(),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => const StoreListScreen(),
//                   ),
//           );
//         } else if (state is AuthLoading) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => const LoadingScreen(),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => const LoadingScreen(),
//                   ),
//           );
//         } else if (state is AuthCodeSent) {
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => VerifyAuthScreen(verificationId: state.verificationId),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => VerifyAuthScreen(verificationId: state.verificationId),
//                   ),
//           );
//         } else if (state is AuthEmailVerification) {
//           // Navigate to a screen that instructs the user to check their email
//           Navigator.of(context).pushReplacement(
//             Platform.isIOS
//                 ? CupertinoPageRoute(
//                     builder: (_) => CheckEmailScreen(email: state.email),
//                   )
//                 : MaterialPageRoute(
//                     builder: (_) => CheckEmailScreen(email: state.email),
//                   ),
//           );
//         }
//       },
//       child: const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator.adaptive(), // Initial loading screen
//         ),
//       ),
//     );
//   }
// }
