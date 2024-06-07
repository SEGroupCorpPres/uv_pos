import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uv_pos/features/presentation/pages/report/report_by_customers_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/report_by_dates_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/report_by_employees_screen.dart';
import 'package:uv_pos/features/presentation/pages/report/sale_report_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Reports'),
        centerTitle: false,
      ),
      body: Card(
        child: ListView.separated(
          itemCount: 4,
          itemBuilder: (context, item) {
            final String title = reportsList[item];
            return ListTile(
              splashColor: Colors.transparent,
              onTap: () {
                switch (item) {
                  case 1:
                    Navigator.push(
                      context,
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const ReportByCustomers(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const ReportByCustomers(),
                            ),
                    );
                  case 2:
                    Navigator.push(
                      context,
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const ReportByEmployees(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const ReportByEmployees(),
                            ),
                    );
                  case 3:
                    Navigator.push(
                      context,
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const ReportByDatesScreen(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const ReportByDatesScreen(),
                            ),
                    );
                  default:
                    Navigator.push(
                      context,
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const SaleReportScreen(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const SaleReportScreen(),
                            ),
                    );
                }
              },
              title: Text(title),
            );
          },
          separatorBuilder: (context, item) {
            return const Divider();
          },
        ),
      ),
    );
  }

  List<String> reportsList = [
    'Sale Reports',
    'Report by Customers',
    'Report by Employee',
    'Report by Dates',
  ];
}
