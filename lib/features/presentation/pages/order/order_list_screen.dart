import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  static Page page() => Platform.isIOS
      ? const CupertinoPage(
          child: OrderListScreen(),
        )
      : const MaterialPage(
          child: OrderListScreen(),
        );

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  StoreModel? store;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToHomeScreen(store),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: const Text('Order List (0/0)'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.qr_code_2),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(size.width, 30),
          child: const Text('Orders Total: \$0 - Unpaid: \$0'),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is OrdersByStoreIDLoaded) {
            List<OrderModel> orders = state.orders!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, item) {
                OrderModel order = orders[item];
                return CupertinoListTile(title: Text(order.id));
              },
            );
          } else if (state is OrderNotFound) {
            return Container(
              alignment: Alignment.center,
              child: const Text('No Record Found'),
            );
          } else if (state is OrderError) {
            return Container(
              alignment: Alignment.center,
              child: const Text('No Record Found'),
            );
          }
          return Container(
            alignment: Alignment.center,
            child: const Text('No Record Found'),
          );
        },
      ),
    );
  }
}
