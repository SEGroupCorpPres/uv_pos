import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/chart_item.dart';
import 'package:uv_pos/features/presentation/widgets/chart_name.dart';
import 'package:uv_pos/features/presentation/widgets/search_dialog.dart';
import 'package:uv_pos/features/presentation/widgets/search_dialog_field.dart';

class SaleReportScreen extends StatefulWidget {
  const SaleReportScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: SaleReportScreen(),
  )
      : const MaterialPage(
    child: SaleReportScreen(),
  );
  @override
  State<SaleReportScreen> createState() => _SaleReportScreenState();
}

class _SaleReportScreenState extends State<SaleReportScreen> {
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  late TextEditingController employeeController;
  late TextEditingController customerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
    employeeController = TextEditingController();
    customerController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fromDateController.dispose();
    toDateController.dispose();
    employeeController.dispose();
    customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToReportsScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Sale Report'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return _filterDialogWidget(context);
                },
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChartName(color: Colors.blueAccent, title: 'Orders Total'),
                SizedBox(width: 30),
                ChartName(color: Colors.redAccent, title: 'Total unpaid'),
              ],
            ),
            const SizedBox(height: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChartItem(title: 'Employee'),
                ChartItem(title: 'Customers'),
                ChartItem(title: 'Payment Method'),
                ChartItem(title: 'Products'),
                ChartItem(
                  title: 'Profit',
                  price: '0',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) => [
        Flexible(
          child: CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Reset Filter'),
          ),
        ),
        Flexible(
          child: CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: const Text('Search'),
          ),
        ),
      ];

  List<Widget> _fieldList(BuildContext context) => [
        SearchDialogField(controller: fromDateController, title: 'From Date:', onTap: () {}),
        const SizedBox(height: 15),
        SearchDialogField(controller: toDateController, title: 'To Date:', onTap: () {}),
        const SizedBox(height: 15),
        SearchDialogField(
          controller: employeeController,
          title: 'Employee:',
          onTap: () {},
          isDateField: false,
        ),
        const SizedBox(height: 15),
        SearchDialogField(
          controller: customerController,
          title: 'Customer:',
          onTap: () {},
          isDateField: false,
        ),
      ];

  Widget _filterDialogWidget(BuildContext context) {
    return SearchDialog(
      fieldList: _fieldList(context),
      actionList: _actions(context),
    );
  }
}
