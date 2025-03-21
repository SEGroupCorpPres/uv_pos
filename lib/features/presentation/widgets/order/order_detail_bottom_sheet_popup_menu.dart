import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailBottomSheetPopupMenu extends StatelessWidget {
  const OrderDetailBottomSheetPopupMenu({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return             Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MediaQuery.removeViewPadding(
            removeTop: true,
            context: context,
            child: Text(
              'Order detail',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: onTap,
                child: Row(
                  children: [
                    const Icon(Icons.local_atm),
                    SizedBox(width: 10.w),
                    Text(
                      'Show Receipt',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
