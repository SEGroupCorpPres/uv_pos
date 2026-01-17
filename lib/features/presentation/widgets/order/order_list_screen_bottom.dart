import 'package:flutter/material.dart';
import 'order.dart';

PreferredSizeWidget orderListScreenBottom({
  required BuildContext context,
  required Size size,
  required bool isSearchTap,
  required TextEditingController searchController,
  required ValueChanged<String> onChanged,
  required String totalAmount,
  required String unpaidAmount,
}) {
  return PreferredSize(
    preferredSize: Size(size.width, isSearchTap ? 60.h : 30.h),
    child: Column(
      children: [
        isSearchTap
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                child: TextField(
                  controller: searchController,
                  onChanged: onChanged,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              )
            : Container(),
        Text('Orders Total: $totalAmount - Unpaid: $unpaidAmount'),
      ],
    ),
  );
}
