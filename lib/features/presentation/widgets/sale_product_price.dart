import 'package:flutter/material.dart';

class SaleProductPrice extends StatelessWidget {
  const SaleProductPrice({super.key, required this.title, this.price, this.procedure, this.discountingPrice});

  final String title;
  final String? price;
  final double? procedure;
  final double? discountingPrice;

  @override
  Widget build(BuildContext context) {
    print('order price is $price');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
          procedure == null
              ? Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    price!,
                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                )
              : Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    '$procedure%(UZS $discountingPrice)',
                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                  ),
                ),
        ],
      ),
    );
  }
}
