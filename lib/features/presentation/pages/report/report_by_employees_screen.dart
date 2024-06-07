import 'package:flutter/material.dart';

class ReportByEmployees extends StatefulWidget {
  const ReportByEmployees({super.key});

  @override
  State<ReportByEmployees> createState() => _ReportByEmployeesState();
}

class _ReportByEmployeesState extends State<ReportByEmployees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Report by Employees'),
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
