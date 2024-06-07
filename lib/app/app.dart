import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/pages/home/home_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/sale_report_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(
          color: Colors.deepPurple,
        ),
        primaryIconTheme: const IconThemeData(
          color: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      // home: ReportByDatesScreen(),
      // home: ReportByEmployees(),
      // home: ReportByCustomers(),
      home: SaleReportScreen(),
      // home: ReportsScreen(),
      // home: StoreListScreen(),
      // home: const HomeScreen(),
    );
  }
}
