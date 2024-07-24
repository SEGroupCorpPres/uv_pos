import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uv_pos/app/presentation/bloc/auth/app_bloc.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/store_model.dart';
import 'package:uv_pos/features/presentation/bloc/order/order_bloc.dart';
import 'package:uv_pos/features/presentation/widgets/order_list_group_header_date.dart';

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
  final ScrollController _scrollController = ScrollController();
  double orderTotalAmount = 0;
  int orderLength = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    initializeDateFormatting('uz_UZ', null);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => BlocProvider.of<AppBloc>(context).add(
            NavigateToHomeScreen(store),
          ),
          child: Icon(Icons.adaptive.arrow_back),
        ),
        title: Text('Order List (0/${orderLength})'),
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
          child: Text('Orders Total: UZS $orderTotalAmount - Unpaid: UZS 0'),
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, orderState) {
          if (orderState is OrdersFromDateByStoreIDLoaded) {
            List<OrderModel> orders = orderState.orders!;
            // double totalAmount = 0;
            orderLength = orders.length;
            for (var order in orders) {
              orderTotalAmount += order.totalAmount;
            }
            setState(() {});
          }
        },
        builder: (context, orderState) {
          if (orderState is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (orderState is OrdersFromDateByStoreIDLoaded) {
            List<OrderModel> orders = orderState.orders!;
            // double totalAmount = 0;
            // orderLength = orders.length;
            // for (var order in orders) {
            //   orderTotalAmount += order.totalAmount;
            // }
            return GroupedListView<OrderModel, DateTime>(
              controller: _scrollController,
              elements: orders,
              groupBy: (OrderModel order) => DateTime(
                order.orderDate.year,
                order.orderDate.month,
                order.orderDate.day,
              ),
              groupHeaderBuilder: (OrderModel order) {
                DateTime date = order.orderDate;
                String formattedDate = DateFormat(
                  'd MMMM yyyy, HH:mm',
                ).format(date);
                return GroupHeaderDate(
                  date: formattedDate,
                );
              },
              itemComparator: (order1, order2) => order2.compareTo(order1),
              itemBuilder: (context, OrderModel order) {
                DateTime date = order.orderDate;
                String formattedTime = DateFormat(
                  'HH:mm',
                ).format(date);
                String formattedDate = DateFormat(
                  'd MMMM yyyy, HH:mm',
                ).format(date);
                return CupertinoListTile(
                  title: Text('ID: ${order.id}'),
                  subtitle: Text('Time: $formattedTime'),
                  trailing: Text('Price: UZS ${order.totalAmount}'),
                );
              },
              useStickyGroupSeparators: true,
              floatingHeader: true,
              order: GroupedListOrder.ASC, // optional
            );
          } else if (orderState is OrderNotFound) {
            return Container(
              alignment: Alignment.center,
              child: const Text('No Record Found'),
            );
          } else if (orderState is OrderError) {
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
