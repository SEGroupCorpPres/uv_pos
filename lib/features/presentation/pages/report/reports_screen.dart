import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: ReportsScreen(),
        )
      : const MaterialPage(
          child: ReportsScreen(),
        );

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
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToHomeScreen(),
          ),
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
                    BlocProvider.of<AppBloc>(context).add(
                      NavigateToReportByCustomersScreen(),
                    );
                  case 2:
                    BlocProvider.of<AppBloc>(context).add(
                      NavigateToReportByEmployeeScreen(),
                    );
                  case 3:
                    BlocProvider.of<AppBloc>(context).add(
                      NavigateToReportByDatesScreen(),
                    );
                  default:
                    BlocProvider.of<AppBloc>(context).add(
                      NavigateToSaleReportScreen(),
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
