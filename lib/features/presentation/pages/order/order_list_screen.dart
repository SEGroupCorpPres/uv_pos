import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  NumberFormat formatAmount = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

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
        title: Text('Order List ($orderLength/$orderLength)'),
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
          child: Text('Orders Total: ${formatAmount.format(orderTotalAmount)} - Unpaid: ${formatAmount.format(0)}'),
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
            orders = orders.reversed.toList();
            // return ListView.builder(
            //   itemCount: orders.length,
            //   itemBuilder: (context, int item) {
            //     OrderModel order = orders[item];
            //     DateTime date = orders[item].orderDate;
            //     String formattedTime = DateFormat(
            //       'HH:mm',
            //     ).format(date);
            //     String formattedDate = DateFormat(
            //       'd/MM/yyyy, HH:mm:ss',
            //     ).format(date);
            //     return CupertinoListTile(
            //       onTap: (){},
            //       title: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             formatAmount.format(order.totalAmount),
            //             style: TextStyle(color: Colors.black, fontSize: 18.sp),
            //           ),
            //           Text(
            //             formatAmount.format(order.totalAmount),
            //             style: TextStyle(color: Colors.blueAccent.withGreen(200), fontSize: 18.sp),
            //           ),
            //         ],
            //       ),
            //       subtitle: Text(
            //         formattedDate,
            //         style: TextStyle(color: Colors.black, fontSize: 13.sp),
            //       ),
            //     );
            //   },
            //
            // );
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
              itemComparator: (order1, order2) => order1.compareTo(order2),
              itemBuilder: (context, OrderModel order) {
                DateTime date = order.orderDate;
                String formattedTime = DateFormat(
                  'HH:mm',
                ).format(date);
                String formattedDate = DateFormat(
                  'd/MM/yyyy, HH:mm',
                ).format(date);
                return CupertinoListTile(
                  onTap: () {
                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                          onClosing: () {},
                          builder: (context) {
                            return Container();
                          },
                        );
                      },
                    );
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatAmount.format(order.totalAmount),
                        style: TextStyle(color: Colors.black, fontSize: 18.sp),
                      ),
                      Text(
                        formatAmount.format(order.totalAmount),
                        style: TextStyle(color: Colors.blueAccent.withGreen(200), fontSize: 18.sp),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: TextStyle(color: Colors.black, fontSize: 13.sp),
                  ),
                );
              },
              useStickyGroupSeparators: true,
              floatingHeader: true,
              order: GroupedListOrder.DESC, // optional
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
