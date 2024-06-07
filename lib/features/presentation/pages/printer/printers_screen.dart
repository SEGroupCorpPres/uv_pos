import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uv_pos/features/presentation/pages/printer/add_printers_screen.dart';
import 'package:uv_pos/features/presentation/pages/printer/add_printers_screen.dart';
import 'package:uv_pos/features/presentation/pages/stock/stock_adjustment_screen.dart';

class PrintersScreen extends StatefulWidget {
  const PrintersScreen({super.key});

  @override
  State<PrintersScreen> createState() => _PrintersScreenState();
}

class _PrintersScreenState extends State<PrintersScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Printers (0)'),
        centerTitle: false,
      ),
      body: const Center(
        child: Text('No record found'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          Platform.isIOS
              ? CupertinoPageRoute(
            builder: (_) => const AddPrintersScreen(),
          )
              : MaterialPageRoute(
            builder: (_) => const AddPrintersScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

}
