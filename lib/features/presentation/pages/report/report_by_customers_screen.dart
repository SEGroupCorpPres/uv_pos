import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';

class ReportByCustomersScreen extends StatefulWidget {
  const ReportByCustomersScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: ReportByCustomersScreen(),
  )
      : const MaterialPage(
    child: ReportByCustomersScreen(),
  );
  @override
  State<ReportByCustomersScreen> createState() => _ReportByCustomersScreenState();
}

class _ReportByCustomersScreenState extends State<ReportByCustomersScreen> {
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
        title: const Text('Report by Customers'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: const Center(
        child: Text('No record found'),
      ),
    );
  }
}
