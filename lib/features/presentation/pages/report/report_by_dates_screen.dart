import 'package:flutter/material.dart';

class ReportByDatesScreen extends StatefulWidget {
  const ReportByDatesScreen({super.key});

  @override
  State<ReportByDatesScreen> createState() => _ReportByDatesScreenState();
}

class _ReportByDatesScreenState extends State<ReportByDatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),

          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Report by Dates'),
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
