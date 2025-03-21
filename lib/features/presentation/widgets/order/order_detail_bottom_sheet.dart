import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uv_pos/features/data/remote/models/order_model.dart';
import 'package:uv_pos/features/data/remote/models/order_product_model.dart';
import 'package:uv_pos/features/data/remote/models/product_model.dart';
import 'package:uv_pos/features/presentation/widgets/order/order_detail_bottom_sheet_popup_menu.dart';

import 'package:uv_pos/generated/assets.dart';

class OrderDetailBottomSheet extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderDetailBottomSheet({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    NumberFormat formatAmount = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );
    initializeDateFormatting('uz_UZ', null);
    DateTime date = order.orderDate;
    String formattedDate = DateFormat(
      'd/MM/yyyy, HH:mm',
    ).format(date);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            OrderDetailBottomSheetPopupMenu(onTap: onTap),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.h),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 5.h,
                  children: [
                    SizedBox(height: 10.h),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text(
                            formatAmount.format(order.totalAmount),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.greenAccent, fontSize: 18.sp),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text(
                            'Total',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 18.sp),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Employee',
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              ),
                              Text(
                                order.employeeName,
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer',
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                order.customerName,
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Products',
                              style: TextStyle(color: Colors.black, fontSize: 15.sp),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: order.productList.length,
                                itemBuilder: (context, item) {
                                  OrderProductModel product = order.productList[item];
                                  return CupertinoListTile(
                                    leadingSize: 40.r,
                                    leading: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: product.thumbnail != null ? NetworkImage(product.thumbnail!) : const AssetImage(Assets.imagesImageBg),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      product.name,
                                      softWrap: true,
                                    ),
                                    subtitle: Text(
                                      '${product.quantity} x ${formatAmount.format(product.price.toInt())}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    trailing: SizedBox(
                                      height: 32.sp,
                                      child: Text(
                                        formatAmount.format((product.quantity * product.price)),
                                        style: TextStyle(fontSize: 15.sp),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payments',
                              style: TextStyle(color: Colors.black, fontSize: 15.sp),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                                Text(
                                  formatAmount.format(order.totalAmount),
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Received by: ',
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                                Text(
                                  order.employeeName,
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment method:',
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                                Text(
                                  'Cash',
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(color: Colors.greenAccent, fontSize: 18.sp),
                                ),
                                Text(
                                  formatAmount.format(order.totalAmount),
                                  style: TextStyle(color: Colors.greenAccent, fontSize: 18.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Received Amount',
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                                Text(
                                  formatAmount.format(order.totalAmount),
                                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
