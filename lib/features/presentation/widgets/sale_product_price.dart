import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaleProductPrice extends StatelessWidget {
  const SaleProductPrice({
    super.key,
    required this.title,
    this.price,
    this.procedure,
    this.discountingPrice,
    this.textAlign = TextAlign.end,
    this.fontSize = 15,
    this.fontColor =  Colors.black,
  });

  final String title;
  final String? price;
  final double? procedure;
  final String? discountingPrice;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5).r,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              title,
              style: TextStyle(color: fontColor, fontSize: fontSize!.sp, fontWeight: FontWeight.w600),
              textAlign: textAlign,
            ),
          ),
          procedure == null
              ? Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    price!,
                    style: TextStyle(color:fontColor, fontSize: fontSize!.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                )
              : Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '$procedure%($discountingPrice)',
                    style: TextStyle(color: Colors.black, fontSize: fontSize!.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                ),
        ],
      ),
    );
  }
}
