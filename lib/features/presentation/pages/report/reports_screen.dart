import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';

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
  String? storeID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getStoreID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    storeID = preferences.getString('store_id');
  }

  @override
  Widget build(BuildContext context) {
    getStoreID();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.read<AppBloc>().add(
          const NavigateToHomeScreen(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => BlocProvider.of<AppBloc>(context).add(
              const NavigateToHomeScreen(),
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
                      print('storeID is  ----------> $storeID');
                      BlocProvider.of<AppBloc>(context).add(
                        NavigateToSaleReportScreen(),
                      );
                      BlocProvider.of<OrderBloc>(context).add(
                            LoadOrdersEvent(storeID),
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
