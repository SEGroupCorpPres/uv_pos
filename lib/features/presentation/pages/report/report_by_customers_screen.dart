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
  ScrollController _scrollController = ScrollController();
  DateTime _currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _currentDateTime = DateTime.now().add(Duration(days: offset.toInt()));
    });
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
        title: const Text('Report by Customers'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Current DateTime: $_currentDateTime',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_currentDateTime.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}
