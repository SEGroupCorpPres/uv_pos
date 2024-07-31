import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/local/models/wrap_button_model.dart';
import 'package:uv_pos/features/presentation/widgets/search_dialog.dart';
import 'package:uv_pos/features/presentation/widgets/search_dialog_field.dart';

class ReportByEmployeesScreen extends StatefulWidget {
  const ReportByEmployeesScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: ReportByEmployeesScreen(),
  )
      : const MaterialPage(
    child: ReportByEmployeesScreen(),
  );
  @override
  State<ReportByEmployeesScreen> createState() => _ReportByEmployeesScreenState();
}

class _ReportByEmployeesScreenState extends State<ReportByEmployeesScreen> {
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  late TextEditingController searchController;

  List<WrapButtonModel> wrapButtons(BuildContext context) => [
        WrapButtonModel(name: 'Today', onPressed: () {}),
        WrapButtonModel(name: 'Yesterday', onPressed: () {}),
        WrapButtonModel(name: 'This Week', onPressed: () {}),
        WrapButtonModel(name: 'Lst Week', onPressed: () {}),
        WrapButtonModel(name: 'This Month', onPressed: () {}),
        WrapButtonModel(name: 'Last Month', onPressed: () {}),
      ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fromDateController.dispose();
    toDateController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.read<AppBloc>().add(
           NavigateToReportsScreen(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: InkWell(
            onTap: () => BlocProvider.of<AppBloc>(context).add(
              NavigateToReportsScreen(),
            ),
            child: Icon(Icons.adaptive.arrow_back),
          ),
          title: const Text('Report by Employees'),
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
        body: const Center(
          child: Text('No record found'),
        ),
      ),
    );
  }

  Widget _filterDialogWidget(BuildContext context) {
    return SearchDialog(
      fieldList: _fieldList(context),
      actionList: Platform.isIOS ? _actionsCupertino(context) : _actionsMaterial(context),
      // actionList: _actionsCupertino(context),
    );
  }

  List<Widget> _actionsMaterial(BuildContext context) => [
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

  List<Widget> _actionsCupertino(BuildContext context) => [
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
        TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Search',
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SearchDialogField(controller: fromDateController, title: 'From Date:', onTap: () {}),
        const SizedBox(height: 15),
        SearchDialogField(controller: toDateController, title: 'To Date:', onTap: () {}),
        const SizedBox(height: 15),
        _quickSearchButtons(context),
      ];

  Widget _quickSearchButtons(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      runAlignment: WrapAlignment.spaceBetween,
      alignment: WrapAlignment.spaceBetween,
      children: wrapButtons(context)
          .map(
            (item) => TextButton(
              style: TextButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                  minimumSize: Size(MediaQuery.sizeOf(context).width / 2 - 60.w, 35.h)),
              onPressed: item.onPressed,
              child: Text(
                item.name,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList(),
    );
  }
}
