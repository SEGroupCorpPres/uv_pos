import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/presentation/pages/stock/stock_adjustment_screen.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});
  static Page page() => Platform.isIOS
      ? const CupertinoPage(
    child: StocksScreen(),
  )
      : const MaterialPage(
    child: StocksScreen(),
  );
  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToHomeScreen(),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Stocks (0/0)'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const Center(
        child: Text('No record found'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => BlocProvider.of<AppBloc>(context).add(
          NavigateToStockAdjustmentScreen(),
        ),
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}
