import 'package:flutter/material.dart';

class ReportByCustomers extends StatefulWidget {
  const ReportByCustomers({super.key});

  @override
  State<ReportByCustomers> createState() => _ReportByCustomersState();
}

class _ReportByCustomersState extends State<ReportByCustomers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
